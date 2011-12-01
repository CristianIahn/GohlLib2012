package br.com.gohlsolucoes.controls
{
	import flashx.textLayout.conversion.TextConverter;
	
	import mx.controls.List;
	
	import spark.components.IItemRenderer;
	import spark.components.RichText;
	import spark.components.supportClasses.ItemRenderer;
	
	public class IRGAutoComplete extends ItemRenderer implements IItemRenderer
	{
		protected var rtext:RichText;
		
		public function IRGAutoComplete()
		{
			super();
			
			createRichText();
		}
		
		protected function createRichText():void
		{
			rtext = new RichText;
			this.addElement(rtext);
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value != null)
			{
				rtext.textFlow = TextConverter.importToFlow(label, TextConverter.TEXT_FIELD_HTML_FORMAT);
			}
		}
	}
}