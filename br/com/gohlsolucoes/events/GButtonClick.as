/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl [cristian.gohl@live.com]
 * http://www.gohlsolucoes.com.br
 ****************************************/

package br.com.gohlsolucoes.events
{
	import flash.events.MouseEvent;
	
	public class GButtonClick extends MouseEvent
	{
		public var label:String = "";
		
		public function GButtonClick(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}