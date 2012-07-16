/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.skins.SGRadioButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.RadioButton;
	
	public class GRadioButton extends RadioButton
	{
		public function GRadioButton()
		{
			super();
			this.setStyle('skinClass', br.com.gohlsolucoes.skins.SGRadioButton);
			this.buttonMode = true;
		}
		
		//----------------------------------
		//  selected
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			invalidateDisplayList();
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
	}
}