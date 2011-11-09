package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.skins.SGFormItem;
	
	import spark.components.FormItem;
	
	public class GFormItem extends FormItem
	{
		[Embed("../assets/p16/obrigatorio.png")] // [Embed(source="../assets/p16/buscar.png")] Diferença??
		protected const OBRIGATORIO_ICON:Class;
		
		public function GFormItem()
		{
			super();
			this.setStyle('skinClass', br.com.gohlsolucoes.skins.SGFormItem);
			this.setStyle('requiredIndicatorSource', OBRIGATORIO_ICON);
		}
		
	}
}