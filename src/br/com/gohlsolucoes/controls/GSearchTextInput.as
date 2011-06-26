/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.Gohl;
	import br.com.gohlsolucoes.events.GSimpleSearchReturnEvt;
	import br.com.gohlsolucoes.skins.buttons.b16.SBBuscarIcone;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import spark.components.Button;
	import spark.components.SkinnableContainer;
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	/**
	 *  <p>Dispara o evento change quando for setado algum item,
	 *  tanto por meio de busca, quanto por <code>setItem(codigo)</code>
	 *  não disparando quando limpar <code>clean()</code>.
	 * 
	 *  @eventType spark.events.TextOperationEvent.CHANGE
	 */
	[Event(name="change", type="spark.events.TextOperationEvent")]
	
	public class GSearchTextInput extends SkinnableContainer
	{
		//----------------------------------
		//  Variáveis
		//----------------------------------
		/**
		 * @private
		 * Text Input utilizado para construir o GSearchTextInput
		 */
		private var sti:TextInput;
		
		/**
		 * @private
		 */
		private var searchButton:Button;
		
		/**
		 * @private
		 */
		private var cleanButton:Button;
		
		/**
		 * @private
		 */
		private var servico:RemoteObject;
		
		/**
		 * @private
		 */
		private var sDiferencial:String;
		
		/**
		 * @private
		 */
		private var _destination:String = "";
		
		/**
		 * @private
		 */
		private var _source:String = "";
		
		/**
		 * @private
		 * Guarda Parametro Adicional para Consulta
		 */
		private var _paramAdd:String = "";
		
		/**
		 * @private
		 */
		private var _columns:ArrayList = new ArrayList;
		
		/**
		 * @private
		 */
		[Bindable("change")]
		private var _selectedItem:Object;
		
		/**
		 * @private
		 */
		[Bindable]
		private var _labelField:String = "nome";
		
		/**
		 * @private
		 */
		private var GOHL:Gohl = Gohl.getInstance();
		
		//----------------------------------
		//  Construtor
		//----------------------------------
		
		public function GSearchTextInput()
		{
			super();
			
			attachEventListeners();
			
			createSti();
		}
		
		//----------------------------------
		//  selectedItem
		//----------------------------------
		private function selectedItem(value:Object):void
		{
			this._selectedItem = value;
			
			if ( value == null )
			{
				sti.text = "";
			}
			else
			{
				sti.text = value[labelField].toString();
				
				enableClean();
				
				/* Dispara evento change */
				dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			}
		}
		
		//----------------------------------
		//  labelField
		//----------------------------------
		public function get labelField():String
		{
			return _labelField;
		}
		
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		
		//----------------------------------
		//  prompt
		//----------------------------------
		public function get prompt():String
		{
			return sti.prompt;
		}
		
		public function set prompt(prompt:String):void
		{
			sti.prompt = prompt;
		}
		
		//----------------------------------
		//  source
		//----------------------------------
		public function set source(source:String):void
		{
			this._source = source;
		}
		public function get source():String
		{
			return this._source;
		}
		
		//----------------------------------
		//  destination
		//----------------------------------
		public function set destination(destination:String):void
		{
			this._destination = destination;
		}
		public function get destination():String
		{
			return this._destination;
		}
		
		//----------------------------------
		//  text
		//----------------------------------
		/**
		 * Retorna o texto que está aparecendo no componente.
		 * Não lida diretamente com o objeto, para isto utilizar:
		 * <code>getItem()</code>.
		 */
		public function get text():String
		{
			return sti.text;
		}
		
		//----------------------------------
		//  paramAdd
		//----------------------------------
		
		/**
		 * paramAdd (set)
		 * Recebe String : Parâmetro adicional para complementar a consulta.
		 */
		public function set paramAdd(_paramAdd:String):void
		{
			this._paramAdd = _paramAdd;
		}
		
		/**
		 * paramAdd (get)
		 * Retorna String : Parâmetro adicional para complementar a consulta.
		 */
		public function get paramAdd():String
		{
			return this._paramAdd;
		}
		
		//----------------------------------
		//  columns
		//----------------------------------
		public function set columns(columns:ArrayList):void
		{
			this._columns = columns;
		}
		
		public function get columns():ArrayList
		{
			return this._columns;
		}
		
		//----------------------------------
		//  Funções
		//----------------------------------
		protected function createSti():void
		{
			sti = new TextInput;
			
			/* Seta tamanho */
			sti.percentHeight = 100;
			sti.percentWidth = 100;
			
			attachStiEventListeners();
			
			this.addElement(sti);
		}
		
		protected function addCleanButton():void
		{
			cleanButton = new GButton(16, 16, br.com.gohlsolucoes.skins.buttons.b16.SBLimparIcone, false);
			cleanButton.right = 1;
			cleanButton.verticalCenter = 0;
			cleanButton.visible = false;
			cleanButton.toolTip = "Limpar";
			cleanButton.addEventListener(MouseEvent.CLICK, cleanButton_clickHandler);
			
			this.addElement(cleanButton);
		}
		
		protected function addSearchButton():void
		{
			searchButton = new GButton(16, 16, br.com.gohlsolucoes.skins.buttons.b16.SBBuscarIcone, false);
			searchButton.right = 1;
			searchButton.verticalCenter = 0;
			searchButton.toolTip = "Buscar";
			searchButton.addEventListener(MouseEvent.CLICK, searchButton_clickHandler);
			
			this.addElement(searchButton);
		}
		
		protected function addService():void
		{
			servico = new RemoteObject(this.destination);
			servico.showBusyCursor = true;
			servico.source = this.source;
			servico.addEventListener(FaultEvent.FAULT, service_faultHandler);
			servico.addEventListener(ResultEvent.RESULT, onResultService);
		}
		
		[Inspectable(category="Data")]
		/**
		 * Retorna o objeto do item presente no componente, caso contrário null.
		 * <p>Aconselhavel verificação <code>getItem() != null</code>.</p>
		 * @return Object
		 */		
		public function getItem():Object
		{
			return _selectedItem;
		}
		
		[Inspectable(category="Data", arrayType="int")]
		/**
		 * Seta o item, buscando pelo código do mesmo.
		 * <p>Faz uma chamada para função <code>get_codigo(codigo)</code>, utilizando <code>source</code> e <code>destination</code>
		 * informados préviamente no componente.</p>
		 * @param codigo:int - Recebe o código do item.
		 * 
		 */		
		public function setItem(codigo:int):void
		{
			addService();
			
			/* testa para ver se realmente deve buscar */
			if ( codigo > 0 )
			{
				servico.get_codigo(codigo);
			}
			
		}
		
		/**
		 * Adiciona escutas de evento para o componente em geral.
		 */
		protected function attachEventListeners():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		/**
		 * Adiciona escutas de evento para o sti.
		 */
		protected function attachStiEventListeners():void
		{
			sti.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteSti);
			sti.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownSti);
			sti.addEventListener(TextOperationEvent.CHANGING, onChangingSti);
		}
		
		/**
		 * Troca os botões, buscar por limpar, alterando a visibilidade.
		 */
		protected function enableClean():void
		{
			this.searchButton.visible = false;
			this.cleanButton.visible = true;
		}
		
		/**
		 * Responsável pela limpeza do formulário e também por deixar o botão de busca aparecendo,
		 * e o de limpeza invisível.
		 */
		public function clear():void
		{
			this.selectedItem(null);
			
			this.searchButton.visible = true;
			this.cleanButton.visible = false;
			
			/* Dispara evento clear */
			dispatchEvent(new Event(Event.CLEAR));
		}
		
		//----------------------------------
		//  Eventos
		//----------------------------------
		/**
		 * @private
		 * Função executada antes da alteração do texto visualmente(utilizando componente).
		 * Previne a digitação, podendo somente ser setado o texto internamente.
		 */
		private function onChangingSti(event:TextOperationEvent):void
		{
			event.preventDefault();
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			this.sDiferencial = GOHL.createDiferencialString(this);
			
			/* Event Retorno, adiciona escuta para retorno de dados */
			systemManager.addEventListener("GSimpleSearchReturn" + this.source + this.sDiferencial, retorno);
			
			/* Event RemovedFromStage */
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		private function removedFromStage(event:Event) : void
		{
			/* Remove Event Retorno */
			systemManager.removeEventListener("GSimpleSearchReturn" + this.source + this.sDiferencial, retorno);
		}
		
		/**
		 * @private
		 * Adiciona os botões de busca e limpeza.
		 * Verifica se tem coluna setada, caso não tenha obtem as padrões.
		 */
		private function onCreationCompleteSti(event:FlexEvent):void
		{
			addSearchButton();
			addCleanButton();
		}
		
		/**
		 * @private
		 * Função responsável por limpar o componente ou abrir a busca.
		 */
		private function onKeyDownSti(event:KeyboardEvent):void
		{
			var keyPressed:uint = event.keyCode;
			if ( event.keyCode == Keyboard.BACKSPACE || event.keyCode == Keyboard.DELETE || event.keyCode == Keyboard.ESCAPE )
			{
				clear();
			}
			else if ( event.keyCode == Keyboard.ENTER )
			{
				openSearch();
			}
		}
		
		/**
		 * Responsável por instanciar e passar os parâmetros e abrir o componente GSimpleSearch.
		 */
		protected function openSearch():void
		{
			var search:GSimpleSearch = new GSimpleSearch;
			search.destination = this.destination;
			search.source = this.source;
			search.sDiferencial = this.sDiferencial;
			search.paramAdd = this.paramAdd;
			search.columns = this.columns;
			
			PopUpManager.addPopUp(search, FlexGlobals.topLevelApplication as DisplayObject, true);
			PopUpManager.centerPopUp(search);
		}
		
		protected function searchButton_clickHandler(event:MouseEvent):void
		{
			openSearch();
		}
		
		protected function cleanButton_clickHandler(event:MouseEvent):void
		{
			clear();
		}
		
		protected function retorno(event:GSimpleSearchReturnEvt):void
		{
			this.selectedItem(event.objeto);
		}
		
		protected function service_faultHandler(event:FaultEvent):void
		{
			// TODO - utilizar o erro geral? Vou deixar em GOHL ?
			GAlert.add(event.fault.faultString + "\n" + "Erro: " + event.fault.faultCode, "falha");
		}
		
		protected function onResultService(event:ResultEvent):void
		{
			// FIXME - Arrumar de pegar na posição 0, pegar sem posição, mas isto vai do backend.
			this.selectedItem(event.result[0]);
		}
	}
}