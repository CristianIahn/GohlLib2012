/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.skins.SGButton;
	
	import spark.components.Button;
	
	[Style(name="icon", type="Object", inherit="no")]
	[DefaultTriggerEvent("click")]
	[DefaultProperty("label")]
	
	public class GButton extends Button
	{
		public function GButton(text:String = "", icon:* = null, iconPlacement:String = "left" ,width:int = 0, height:int = 0, skin:* = null, focusEnabled:Boolean = true)
		{
			super();
			
			this.label = text;
			
			if ( width != 0 )
			{
				this.width = width;
			}
			if ( height != 0 )
			{
				this.height = height;
			}
			if ( icon != null )
			{
				this.setStyle("icon", icon);
				this.setStyle('iconPlacement', iconPlacement);
			}
			
			this.setStyle("skinClass", skin == null ? br.com.gohlsolucoes.skins.SGButton : skin);
			this.focusEnabled = focusEnabled;
			this.buttonMode = true;
			this.useHandCursor = true;
		}
	}
}