/***************************************
 * 
 * GAutoComplete
 * 
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.gohlsolucoes.com.br
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.Gohl;
	import br.com.gohlsolucoes.controls.GSearchTextInput;
	import br.com.gohlsolucoes.validators.GStringValidator;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import spark.components.Group;
	import spark.components.List;
	import spark.events.TextOperationEvent;
	
	public class GAutoComplete extends GSearchTextInput
	{
		//----------------------------------
		//  Variáveis
		//----------------------------------
		
		/**
		 * @private
		 */
		private var aCList:List;
		
		/**
		 * @private
		 */
		[Bindable]
		private var dpACList:ArrayCollection = new ArrayCollection;
		
		/**
		 * @private
		 */
		private var supPoint:Group = new Group;
		
		//----------------------------------
		//  Construtor
		//----------------------------------
		
		public function GAutoComplete()
		{
			super();
			
			sti.addEventListener(TextOperationEvent.CHANGE, onChangeSti);
			
			attachACEventListeners();
		}
		
		//----------------------------------
		//  Propriedades
		//----------------------------------
		
		private var _openMode:String = "down";
		
		[Inspectable(arrayType="String", enumeration="up,down", defaultValue="down")]
		public function set openMode(mode:String):void
		{
			_openMode = mode;
			supPoint.y = mode == "up" ? -100 : this.height;
		}
		
		//----------------------------------
		//  Funções sobrescritas
		//----------------------------------
		
		protected override function onKeyDownSti(event:KeyboardEvent):void
		{
			var keyPressed:uint = event.keyCode;
			var ctrl:Boolean = event.ctrlKey;
			
			if ( keyPressed == Keyboard.ESCAPE )
			{
				clear();
			}
			else if ( keyPressed == Keyboard.ENTER )
			{
				// Se a List estiver aberta e tiver um item selecionado, então o ENTER seta o item.
				if ( aCList.visible == true && aCList.selectedIndex >= 0 )
				{
					setItem(aCList.selectedItem.codigo);
					DisableACList();
				}
				else
				{
					// Se estiver com o ctrl pressionado, busca pelo AC, caso contrário busca pelo SS.
					if ( ctrl )
					{
						searchAC(this.text);
					}
					else
					{
						openSearch();
					}
				}
			}
			else if ( keyPressed == Keyboard.UP )
			{
				aCList.selectedIndex = aCList.selectedIndex == 0 ? (dpACList.length - 1) : (aCList.selectedIndex - 1);
			}
			else if ( keyPressed == Keyboard.DOWN )
			{
				aCList.selectedIndex = aCList.selectedIndex == (dpACList.length - 1) ? 0 : (aCList.selectedIndex + 1);
			}
		}
		
		/**
		 * @protected
		 * Força o usuário a limpar o componente pelo botão.
		 */
		protected override function onChangingSti(event:TextOperationEvent):void
		{
			if ( this.codigo > 0 )
			{
				event.preventDefault();
			}
		}
		
		protected override function addService():void
		{
			servico = new RemoteObject(this.destination);
			servico.showBusyCursor = true;
			servico.source = this.source;
			servico.addEventListener(FaultEvent.FAULT, service_faultHandler);
			servico.get_codigo.addEventListener(ResultEvent.RESULT, onResultService);
			servico.buscar_nome.addEventListener(ResultEvent.RESULT, onResultBuscarNome);
		}
		
		//----------------------------------
		//  Funções
		//----------------------------------
		
		protected function addSupportPoint():void
		{
			supPoint.width = 5;
			supPoint.height = 5;
			supPoint.y = _openMode == "up" ? -100 : this.height;
			this.addElement(supPoint);
		}
		
		protected function addACList():void
		{
			aCList = new List;
			//aCList.width = this.width;
			//aCList.x = this.x;
			//aCList.y = this.y + this.height;
			aCList.height = 100;
			aCList.dataProvider = dpACList;
			aCList.visible = false;
			aCList.labelField = this.labelField;
			aCList.labelFunction = labelFunctionAC;
			aCList.doubleClickEnabled = true;
			aCList.itemRenderer = new ClassFactory(IRGAutoComplete);
			aCList.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickACList);
			//this.addElement(aCList);
			PopUpManager.addPopUp(aCList, supPoint, false);
			PopUpManager.centerPopUp(aCList);
		}
		
		private function attachACEventListeners():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteAC);
			this.addEventListener(Event.CLEAR, onClear);
			this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutAC);
		}
		
		protected function searchAC(text:String):void
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
					if ( paramAdd != "" && paramAdd2 == "" )
					{
						servico.buscar_nome(text, paramAdd);
					}
					else if ( paramAdd != "" && paramAdd2 != "" )
					{
						servico.buscar_nome(text, paramAdd, paramAdd2);
					}
					else
					{
						servico.buscar_nome(text);
					}
				}
			}
			catch (execao:GException)
			{
				GAlert.add(execao.mensagem, execao.tipo);
			}
			
			aCList.visible = true;
			
			PopUpManager.centerPopUp(aCList);
		}
		
		protected function DisableACList():void
		{
			aCList.visible = false;
		}
		
		protected function labelFunctionAC(item:Object):String
		{
			/* gohl:Gohl = Gohl.getInstance();
			
			var labelWOA:String = gohl.removeAccent(item[labelField]).toLowerCase();
			var textWOA:String = gohl.removeAccent(this.text).toLowerCase();
			
			var styledText:String = '';
			
			var teste:int = labelWOA.search(textWOA);
			
			if ( teste >= 0 )
			{
				if ( teste == 0 )
				{
					styledText += '<b><u>';
					styledText += item[labelField].toString().substr(teste, this.text.length);
					styledText += '</b></u>';
					styledText += item[labelField].toString().substring(this.text.length, item[labelField].toString().length);
				}
				for 
				
			}
			trace(teste);
			
			return styledText;*/
			//trace(item[labelField]);
			return item[labelField].toString().replace( new RegExp(this.text, 'gi'), ('<u><b>' + this.text.toUpperCase() + '</u></b>') );
		}
		
		//----------------------------------
		//  Eventos
		//----------------------------------
		
		protected function onChangeSti(event:TextOperationEvent):void
		{
			searchAC(this.text);
		}
		
		protected function onDoubleClickACList(event:MouseEvent):void
		{
			if ( aCList.selectedIndex >= 0 )
			{
				setItem(aCList.selectedItem.codigo);
				DisableACList();
			}
		}
		
		/**
		 *  Caso não tenha item setado, limpa o texto do STI e desabilita a List.
		 *  SEM DISPARAR O EVENTO CLEAR.
		 */
		protected function onFocusOutAC(event:FocusEvent):void
		{
			if ( this.codigo < 1 )
			{
				sti.text = '';
				DisableACList();
			}
		}
		
		// Quando o STI for limpo, desabilita a List.
		protected function onClear(event:Event):void
		{
			DisableACList();
		}
		
		protected function onResultBuscarNome(event:ResultEvent):void
		{
			dpACList = new ArrayCollection(event.result as Array);
			aCList.dataProvider = dpACList; // <== se setar novamente funciona
			if ( dpACList.length > 0 )
			{
				aCList.selectedIndex = 0;
			}
		}
		
		protected function onCreationCompleteAC(event:FlexEvent):void
		{
			addSupportPoint();
			addACList();
			addService();
		}
	}
}