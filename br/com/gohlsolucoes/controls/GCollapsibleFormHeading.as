/***************************************
 * 
 * GCollapsibleFormHeading
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
	
	import mx.events.FlexEvent;
	import mx.states.State;
	
	import spark.components.FormHeading;
	
	[Event(name="stateChanged", type="br.com.gohlsolucoes.events.GStateChanged")]
	[SkinState('normal', 'collapsed', 'disabled')]
	public class GCollapsibleFormHeading extends FormHeading
	{
		//----------------------------------
		//  Construtor
		//----------------------------------
		
		public function GCollapsibleFormHeading()
		{
			super();
			
			addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onChangeState);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			states = [new State({name:"normal"}),
					  new State({name:"collapsed"}),
					  new State({name:"disabled"})];
		}
		
		//----------------------------------
		//  Funções
		//----------------------------------
		
		public function changeState():void
		{
			// Inverte o state.
			currentState = currentState == 'normal' ? 'collapsed' : 'normal';
		}
		
		//----------------------------------
		//  Eventos
		//----------------------------------
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			this.currentState = 'normal';
		}
		
		protected function onChangeState(event:FlexEvent):void
		{
			var evt:GStateChanged = new GStateChanged(GStateChanged.STATE_CHANGED);
			evt.newState = currentState;
			dispatchEvent(evt);
		}
	}
}