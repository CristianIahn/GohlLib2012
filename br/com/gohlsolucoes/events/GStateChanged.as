package br.com.gohlsolucoes.events
{
	import mx.events.FlexEvent;

	public class GStateChanged extends FlexEvent
	{
		public static const STATE_CHANGED:String = "stateChanged";
		
		public var newState:String;
		
		public function GStateChanged(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}