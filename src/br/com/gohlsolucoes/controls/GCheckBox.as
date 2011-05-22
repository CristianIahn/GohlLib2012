/***************************************
 * Projeto: Advogado
 * Copyright (c) 2011
 * @author Cristian Edson Göhl [cristian.gohl@live.com]
 * http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.skins.SGCheckBox;
	
	import spark.components.CheckBox;
	
	public class GCheckBox extends CheckBox
	{
		public function GCheckBox()
		{
			super();
			this.setStyle('skinClass', br.com.gohlsolucoes.skins.SGCheckBox);
			this.buttonMode = true;
		}
	}
}