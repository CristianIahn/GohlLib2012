package br.com.gohlsolucoes.controls
{
	import flash.events.Event;
	
	import mx.core.IFlexDisplayObject;
	
	import spark.components.RadioButtonGroup;
	
	public class GRadioButtonGroup extends RadioButtonGroup
	{
		public function GRadioButtonGroup(document:IFlexDisplayObject=null)
		{
			super(document);
		}
		
		public override function set selectedValue(value:Object):void
		{
			if (value != super.selectedValue)
			{
				super.selectedValue = value;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}