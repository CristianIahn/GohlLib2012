package br.com.gohlsolucoes.controls.gcustomtabbar {
	import br.com.gohlsolucoes.controls.gcustomtabbar.events.CustomTabBarCloseEvent;
	import br.com.gohlsolucoes.controls.gcustomtabbar.skins.CustomTabBarButtonSkin;
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.ButtonBarButton;
	import spark.components.Label;

	[Event(name='closeTab',type='br.com.gohlsolucoes.controls.gcustomtabbar.events.CustomTabBarCloseEvent')]
	
	[SkinState("dragging")]
	
	public class CustomTabBarButton extends ButtonBarButton {
		
		[SkinPart(required="false")]
		public var closeButton:Button;
		
		private var _closeable:Boolean = true;
		private var _dragging:Boolean = false;
		
		public function CustomTabBarButton() {
			super();
			this.setStyle("skinClass", br.com.gohlsolucoes.controls.gcustomtabbar.skins.CustomTabBarButtonSkin);
			
			//NOTE: this enables the button's children (aka the close button) to receive mouse events
			this.mouseChildren = true;
		}
		
		override public function set dragging(value:Boolean):void {
			if(value != _dragging){
				_dragging = value;
				invalidateSkinState();
			}
		}
		
		override public function get dragging():Boolean {
			return _dragging;
		}
		
		[Bindable]
		public function get closeable():Boolean {
			return _closeable;
		}
		public function set closeable(val:Boolean):void {
			if (_closeable != val) {
				_closeable = val;
				closeButton.visible = val;
				Label(labelDisplay).right = (val ? 30 : 14);
			}
		}
		
		private function closeHandler(e:MouseEvent):void {
			dispatchEvent(new CustomTabBarCloseEvent(CustomTabBarCloseEvent.CLOSE_TAB, itemIndex, true));
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == closeButton) {
				closeButton.addEventListener(MouseEvent.CLICK, closeHandler);
				
				//closeButton.visible = false;
			} else if (instance == labelDisplay) {
				Label(labelDisplay).right = (closeable ? 30 : 14);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == closeButton) {
				closeButton.removeEventListener(MouseEvent.CLICK, closeHandler);
			}
		}
		
		override protected function getCurrentSkinState():String {
			var skinState:String = super.getCurrentSkinState();
			if(_dragging){
				skinState =  "dragging";
			}
			return skinState;
		}
		
		
	}
}