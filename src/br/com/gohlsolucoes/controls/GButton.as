/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import spark.components.Button;
	
	public class GButton extends Button
	{
		public function GButton(width:int = 0, height:int = 0, skin:* = null, focusEnabled:Boolean = true)
		{
			super();
			
			if ( width != 0 )
			{
				this.width = width;
			}
			if ( height != 0 )
			{
				this.height = height;
			}
			if ( skin != null )
			{
				this.setStyle("skinClass", skin);
			}
			
			this.focusEnabled = focusEnabled;
			this.buttonMode = true;
			this.useHandCursor = true;
		}
	}
}