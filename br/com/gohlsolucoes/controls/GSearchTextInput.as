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
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayList;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	import mx.validators.EmailValidator;
	
	import spark.components.Button;
	import spark.components.SkinnableContainer;
	import spark.components.TextInput;
	import spark.components.gridClasses.GridColumn;
	import spark.events.TextOperationEvent;
	
	/**
	 *  <p>Dispara o evento change quando for setado algum item,
	 *  tanto por meio de busca, quanto por <code>setItem(codigo)</code>
	 *  não disparando quando limpar <code>clear()</code>.
	 * 
	 *  @eventType spark.events.TextOperationEvent.CHANGE
	 */
	[IconFile("GSearchTextInput.png")]
	[Event(name="change", type="spark.events.TextOperationEvent")]
	[DefaultTriggerEvent("change")]
	public class GSearchTextInput extends SkinnableContainer
	{
		//----------------------------------
		//  Variáveis
		//----------------------------------
		/**
		 * @protected
		 * Text Input utilizado para construir o GSearchTextInput
		 */
		protected var sti:TextInput;
		
		/**
		 * @private
		 */
		private var searchButton:Button;
		
		/**
		 * @private
		 */
		private var clearButton:Button;
		
		/**
		 * @protected
		 */
		protected var servico:RemoteObject;
		
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
		 * Guarda Parametro Adicional para Consulta
		 */
		private var _paramAdd2:String = "";
		
		/**
		 * @private
		 */
		[Bindable]
		private var _columns:Array = new Array;
		
		/**
		 * @private
		 */
		[Bindable("change")]
		private var _selectedItem:Object = null;
		
		/**
		 * @private
		 */
		[Bindable]
		private var _labelField:String = "nome";
		
		/**
		 * @private
		 */
		private var GOHL:Gohl = Gohl.getInstance();
		
		[Embed("../assets/p16/buscar.png")] // [Embed(source="../assets/p16/buscar.png")] Diferença??
		protected const SEARCH_ICON:Class;
		
		[Embed("../assets/p16/limpar.png")] // [Embed(source="../assets/p16/buscar.png")] Diferença??
		protected const CLEAR_ICON:Class;
		
		//----------------------------------
		//  Construtor
		//----------------------------------
		
		public function GSearchTextInput()
		{
			super();
			
			attachEventListeners();
			
			createSti();
			
			// Para receber focus no textinput.
			//this.hasFocusableChildren = true;
		}
		
		//[ChangeEvent("change")]
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
				
				enableClear();
				
				/* Dispara evento change */
				dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			}
		}
		
		[Inspectable(arrayType="String", category="Common", defaultValue="nome")]
		//----------------------------------
		//  labelField
		//----------------------------------
		public function set labelField(labelField:String):void
		{
			_labelField = labelField;
		}
		
		public function get labelField():String
		{
			return _labelField;
		}
		
		[Inspectable(arrayType="String", category="Common")]
		//----------------------------------
		//  prompt
		//----------------------------------
		public function set prompt(prompt:String):void
		{
			sti.prompt = prompt;
		}
		
		public function get prompt():String
		{
			return sti.prompt;
		}
		
		[Inspectable(arrayType="String", category="Common")]
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
		
		[Inspectable(arrayType="String", category="Common")]
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
		//  paramAdd2
		//----------------------------------
		
		/**
		 * paramAdd2 (set)
		 * Recebe String : Parâmetro adicional2 para complementar a consulta.
		 */
		public function set paramAdd2(_paramAdd2:String):void
		{
			this._paramAdd2 = _paramAdd2;
		}
		
		/**
		 * paramAdd2 (get)
		 * Retorna String : Parâmetro adicional2 para complementar a consulta.
		 */
		public function get paramAdd2():String
		{
			return this._paramAdd2;
		}
		
		//----------------------------------
		//  columns
		//----------------------------------
		public function set columns(columns:Array):void
		{
			this._columns = columns;
		}
		
		public function get columns():Array
		{
			return this._columns;
		}
		
		//----------------------------------
		//  codigo
		//----------------------------------
		public function set codigo(codigo:int):void
		{
			this.setItem(codigo);
		}
		
		public function get codigo():int
		{
			var item:Object = this.getItem();
			
			return item.codigo;
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
			
			/* posição */
			sti.verticalCenter = 0;
			sti.horizontalCenter = 0;
			
			attachStiEventListeners();
			
			this.addElement(sti);
		}
		
		protected function addClearButton():void
		{
			clearButton = new GButton("", CLEAR_ICON, "left", 16, 0, null, false);
			clearButton.right = 1.5;
			clearButton.top = 2;
			clearButton.bottom = 2;
			clearButton.verticalCenter = 0;
			clearButton.visible = false;
			clearButton.toolTip = "Limpar";
			clearButton.addEventListener(MouseEvent.CLICK, clearButton_clickHandler);
			
			this.addElement(clearButton);
		}
		
		protected function addSearchButton():void
		{
			searchButton = new GButton("", SEARCH_ICON, "left", 16, 0, null, false);
			searchButton.right = 1.5;
			searchButton.top = 2;
			searchButton.bottom = 2;
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
			if ( _selectedItem == null )
			{
				_selectedItem = new Object;
				_selectedItem.codigo = 0;
			}
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
			this.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
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
		protected function enableClear():void
		{
			this.searchButton.visible = false;
			this.clearButton.visible = true;
		}
		
		/**
		 * Responsável pela limpeza do formulário e também por deixar o botão de busca aparecendo,
		 * e o de limpeza invisível.
		 */
		public function clear():void
		{
			this.selectedItem(null);
			
			this.searchButton.visible = true;
			this.clearButton.visible = false;
			
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
		protected function onChangingSti(event:TextOperationEvent):void
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
		
		private function onFocusIn(event:FocusEvent):void
		{
			sti.setFocus();
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
			// Gambiarra para o focus.
			sti.tabIndex = this.tabIndex;
			addSearchButton();
			addClearButton();
		}
		
		/**
		 * @private
		 * Função responsável por limpar o componente ou abrir a busca.
		 */
		protected function onKeyDownSti(event:KeyboardEvent):void
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
			search.paramAdd2 = this.paramAdd2;
			search.columns = this.columns;
			
			PopUpManager.addPopUp(search, FlexGlobals.topLevelApplication as DisplayObject, true);
			PopUpManager.centerPopUp(search);
		}
		
		protected function searchButton_clickHandler(event:MouseEvent):void
		{
			openSearch();
		}
		
		protected function clearButton_clickHandler(event:MouseEvent):void
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
			this.selectedItem(event.result);
		}
	}
}