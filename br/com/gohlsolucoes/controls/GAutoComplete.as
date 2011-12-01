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
	import br.com.gohlsolucoes.controls.GSearchTextInput;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
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
		
		protected function addACList():void
		{
			aCList = new List;
			//aCList.width = this.width;
			aCList.x = this.x;
			aCList.y = this.y + this.height;
			aCList.height = 100;
			aCList.dataProvider = dpACList;
			aCList.visible = false;
			aCList.labelField = this.labelField;
			aCList.doubleClickEnabled = true;
			aCList.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickACList);
			PopUpManager.addPopUp(aCList,this, false);
		}
		
		private function attachACEventListeners():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteAC);
			this.addEventListener(Event.CLEAR, onClear);
			this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutAC);
		}
		
		protected function searchAC(text:String):void
		{
			servico.buscar_nome(text);
			
			aCList.visible = true;
		}
		
		protected function DisableACList():void
		{
			aCList.visible = false;
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
			addACList();
			addService();
		}
	}
}