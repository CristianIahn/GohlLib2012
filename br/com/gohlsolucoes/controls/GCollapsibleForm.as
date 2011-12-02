/***************************************
 * 
 * GCollapsibleForm
 * 
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.gohlsolucoes.com.br
 * 
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.events.GStateChanged;
	import br.com.gohlsolucoes.skins.SGCollapsibleForm;
	
	import mx.events.FlexEvent;
	import mx.states.State;
	
	import spark.components.Form;
	import spark.components.FormHeading;
	import spark.components.Label;
	
	[Event(name="stateChanged", type="br.com.gohlsolucoes.events.GStateChanged")]
	[SkinState('normal', 'collapsed', 'error', 'disabled')]
	public class GCollapsibleForm extends Form
	{
		//----------------------------------
		//  Variáveis
		//----------------------------------
		
		[Inspectable(environment="none")]
		[Bindable]
		public var _title:String = '';
		
		//----------------------------------
		//  Construtor
		//----------------------------------
		
		public function GCollapsibleForm()
		{
			super();
			
			addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onChangeState);
			
			states = [new State({name:"normal"}),
					  new State({name:"collapsed"}),
					  new State({name:"error"}),
					  new State({name:"disabled"})];
			
			setStyle('skinClass', br.com.gohlsolucoes.skins.SGCollapsibleForm);
		}
		
		//----------------------------------
		//  Parâmetros
		//----------------------------------
		
		public function set title(title:String):void
		{
			_title = title;
		}
		
		public function get title():String
		{
			return _title;
		}
		
		//----------------------------------
		//  Eventos
		//----------------------------------
		
		protected function onChangeState(event:FlexEvent):void
		{
			var evt:GStateChanged = new GStateChanged(GStateChanged.STATE_CHANGED);
			evt.newState = currentState;
			dispatchEvent(evt);
		}
	}
}