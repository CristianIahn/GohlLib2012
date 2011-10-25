/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl [cristian.gohl@live.com]
 * http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes.events
{
	import flash.events.Event;
	
	public class GAlertEvt extends Event
	{
		public static const REMOVE:String = "remove";
		
		public var resposta:Boolean = false;
		
		public function GAlertEvt(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new GAlertEvt(type, bubbles, cancelable);
		}
	}
}