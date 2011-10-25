/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.events.GSimpleSearchReturnEvt;
	import br.com.gohlsolucoes.skins.STitleWindow;
	import br.com.gohlsolucoes.validators.GStringValidator;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import spark.components.DataGrid;
	import spark.components.TextInput;
	import spark.components.TitleWindow;
	import spark.components.gridClasses.GridColumn;
	
	public class GSimpleSearch extends TitleWindow
	{
		
		//--------------------------------------------------------------------------
		//
		//  Variaveis
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 *  Parâmetro adicional, utilizado na busca.
		 */
		private var _paramAdd:String = "";
		
		/**
		 *  @private
		 */
		private var gridBusca:DataGrid;
		
		/**
		 *  @private
		 */
		[Bindable]
		private var _columns:ArrayList = new ArrayList;
		
		/**
		 *  @private
		 *  TextInput utilizado para digitar o termo a ser buscado.
		 */
		private var tiBusca:TextInput;
		
		/**
		 *  @private
		 *  String que auxilia para diferenciar várias instacincias do mesmo comp.
		 */
		private var _sDiferencial:String;
		
		/**
		 *  @private
		 */
		private var servico:RemoteObject;
		
		/**
		 *  @private
		 */
		[Bindable]
		private var lista:ArrayCollection = new ArrayCollection;
		
		/**
		 *  @private
		 *  Armazena o ultimo termo buscado.
		 */
		private var buscado:String = "Default"; //poderia utilizar ChangeWatcher ?
		
		/**
		 * @private
		 */
		private var _prompt:String = "Digite aqui para pesquisar";
		
		//--------------------------------------------------------------------------
		//
		//  Construtor
		//
		//--------------------------------------------------------------------------
		public function GSimpleSearch()
		{
			super();
			this.minHeight = 300;
			addGrid();
			addBusca();
			this.setStyle("skinClass", br.com.gohlsolucoes.skins.STitleWindow);
			addServico();
			
			// Event Creation Complete
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
			
			// Event Close
			this.addEventListener(CloseEvent.CLOSE, BTISearch_closeHandler);
			
			// Event KeyDown
			this.addEventListener( KeyboardEvent.KEY_DOWN, BTISearch_keyDown );
		}
		
		//----------------------------------
		//  source
		//----------------------------------
		[Inspectable(arrayType="String", category="Common")]
		/**
		 * source (set)
		 * Recebe String : source do serviço.
		 */
		public function set source(source:String):void
		{
			this.servico.source = source; // Setei assim pra fugir do Bindable
		}
		
		//----------------------------------
		//  destination
		//----------------------------------
		[Inspectable(arrayType="String", category="Common")]
		/**
		 * destination (set)
		 * Recebe String : destination do serviço.
		 */
		public function set destination(destination:String):void
		{
			this.servico.destination = destination; // Setei assim pra fugir do Bindable
		}
		
		//----------------------------------
		//  paramAdd
		//----------------------------------
		[Inspectable(arrayType="String", category="Common")]
		/**
		 * paramAdd (set)
		 * Recebe String : Parâmetro adicional para complementar a consulta.
		 */
		public function set paramAdd(_paramAdd:String):void
		{
			this._paramAdd = _paramAdd;
		}
		
		//----------------------------------
		//  sDiferencial
		//----------------------------------
		[Inspectable(arrayType="String", category="Common")]
		public function set sDiferencial(sDiferencial:String):void
		{
			this._sDiferencial = sDiferencial;
		}
		
		//----------------------------------
		//  columns
		//----------------------------------
		[Inspectable(arrayType="Array", category="Common")]
		public function set columns (columns:Array):void
		{
			//if ( columns.length > 0 )
			//{
				//this._columns = columns;
				for ( var a:int = 0; a < columns.length; a++ )
				{
					addColumn(columns[a].nome, columns[a].dataField, columns[a].tamanho);
				}
			//}
		}
		
		//----------------------------------
		//  Funções
		//----------------------------------
		/**
		 * addColuna
		 */
		public function addColumn(nome:String, dataField:String, widht:Number):void
		{
			this._columns.addItem( createColumn(nome, dataField, widht, false) );
		}
		
		private function createColumn(name:String, dataField:String, widht:Number, editable:Boolean = false):GridColumn
		{
			var newColumn:GridColumn = new GridColumn(name);
			newColumn.dataField = dataField;
			newColumn.width = widht;
			newColumn.editable = editable;
			
			return newColumn;
		}
		
		protected function search():void
		{
			try
			{
				var errorMessage:String = "";
				errorMessage += GStringValidator.validateNow(this.servico.destination, "Destino");
				errorMessage += errorMessage.length > 0 ? "\n" + GStringValidator.validateNow(this.servico.source, "Fonte")
														: GStringValidator.validateNow(this.servico.source, "Fonte");
				
				if ( errorMessage.length > 0 )
				{
					throw new GException(errorMessage,"falha");
				}
				else
				{
					if ( this._paramAdd != "" )
					{
						servico.buscar_nome(tiBusca.text, this._paramAdd);
					}
					else
					{
						servico.buscar_nome(tiBusca.text);
					}
				}
			}
			catch (execao:GException)
			{
				GAlert.add(execao.mensagem, execao.tipo);
			}
		}
		
		/**
		 * Adiciona a grid no Title Window.
		 */
		protected function addGrid():void
		{
			gridBusca = new DataGrid();
			gridBusca.setStyle("borderAlpha", "0.5");
			gridBusca.setStyle("borderColor", "#b7babc");
			gridBusca.left = 0;
			gridBusca.right = 0;
			gridBusca.top = 0;
			gridBusca.bottom = 40;
			gridBusca.doubleClickEnabled = true;
			gridBusca.dataProvider = this.lista;
			gridBusca.columns = this._columns;
			gridBusca.addEventListener( MouseEvent.DOUBLE_CLICK, tabelaBusca_doubleClickHandler );
			this.addElement(gridBusca);
		}
		
		/**
		 * Adiciona um TextInput utilizado para busca.
		 */
		protected function addBusca():void
		{
			tiBusca = new TextInput();
			tiBusca.left = 5;
			tiBusca.right = 5;
			tiBusca.bottom = 5;
			tiBusca.prompt = this._prompt;
			tiBusca.addEventListener( Event.CHANGE,onChangeTiBusca );//poderia utilizar ChangeWatcher ?
			tiBusca.addEventListener( KeyboardEvent.KEY_DOWN, tiBusca_keyDownHandler );
			tiBusca.addEventListener( FlexEvent.ENTER, tiBusca_enterHandler );
			this.addElement(tiBusca);
		}
		
		/**
		 * Adiciona o serviço utilizado para buscar.
		 */
		protected function addServico():void
		{
			servico = new RemoteObject("");
			servico.showBusyCursor = true;
			servico.source = "";
			servico.addEventListener(FaultEvent.FAULT, servico_faultHandler);
			servico.addEventListener(ResultEvent.RESULT, onResultServico);
		}
		
		/**
		 * Cria um evento de retorno, populando objeto nele existe com os dados buscados.
		 * @see GSimpleSearchReturnEvt.as
		 */		
		protected function disparaRetorno():void
		{
			var evt:GSimpleSearchReturnEvt = new GSimpleSearchReturnEvt("GSimpleSearchReturn" + this.servico.source + this._sDiferencial);
			evt.objeto = this.gridBusca.selectedItem;
			systemManager.dispatchEvent(evt);
		}
		
		//----------------------------------
		//  Eventos
		//----------------------------------
		/**
		 * @private
		 */
		protected function BTISearch_keyDown(event:KeyboardEvent):void
		{
			if ( event.keyCode == Keyboard.ESCAPE )
			{
				PopUpManager.removePopUp(this);
			}
		}
		
		/**
		 * @private
		 * Responsável por remover a popup.
		 */
		private function BTISearch_closeHandler(event:CloseEvent):void
		{
			PopUpManager.removePopUp(this);
		}
		
		/**
		 * @private
		 * Atribui o focus no campo de busca.
		 */
		private function creationComplete(event:Event):void
		{
			if ( this._columns.length < 1 )
			{
				addColumn("Código", "codigo", 60);
				addColumn("Nome", "nome", 335);
			}
			
			tiBusca.setFocus()
		}
		
		/**
		 * Recebe a falhe de evento e a exibe.
		 * @param event(FaultEvent) - Falha de evento.
		 */
		protected function servico_faultHandler(event:FaultEvent):void
		{
			GAlert.add(event.fault.faultString + "\n" + "Erro: " + event.fault.faultCode, "falha");
		}
		
		/**
		 * Função que recebe o retorno da busca, atribui o retorno para a grid e guarda o que foi buscado.
		 * @param event
		 */		
		protected function onResultServico(event:ResultEvent):void
		{
			this.lista = new ArrayCollection(event.result as Array);
			gridBusca.dataProvider = this.lista; // <== se setar novamente funciona
			gridBusca.selectedIndex = 0;
			this.buscado = tiBusca.text;
		}
		
		protected function onChangeTiBusca(event:Event):void
		{
			this.title = tiBusca.text.toLocaleUpperCase();
			search();
		}
		
		protected function tiBusca_enterHandler(event:FlexEvent):void
		{
			if ( gridBusca.selectedIndex < 0 )
			{
				if ( this.buscado != tiBusca.text )
				{
					search();
				}
				else
				{
					GAlert.add("Busca repetida!", "falha");
				}
				
			}
			else
			{
				PopUpManager.removePopUp(this);
				disparaRetorno();
			}
			
		}
		
		protected function tabelaBusca_doubleClickHandler(event:MouseEvent):void
		{
			if ( gridBusca.selectedIndex < 0 )
			{
				search();
			}
			else
			{
				PopUpManager.removePopUp(this);
				disparaRetorno();
			}
		}
		
		protected function tiBusca_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN)
			{
				gridBusca.dispatchEvent(event);
			}
		}
	}
}