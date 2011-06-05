/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl [cristian.gohl@live.com]
 * http://www.kiveo.com.br
 ****************************************/
package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.skins.SGClock;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class GClock extends SkinnableComponent
	{
		private var ticker:Timer;
		[Bindable] public var _time:String;
		[Bindable] public var _date:String;
		[Bindable] private var _refreshTime:int = 45000;
		[Bindable] public var _position:String = 'normal';
		
		public function GClock()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			this.setStyle('skinClass', br.com.gohlsolucoes.skins.SGClock);
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			atualizar();
			comecarContador();
		}
		
		private function atualizar():void
		{
			// Pega data atual
			var currentTime:Date = new Date();
			
			// Monta hora, sempre ficando no formato hh:ii
			_time = currentTime.hours.toString().length < 2 ? "0" + currentTime.hours.toString() : currentTime.hours.toString();
			_time += ":";
			_time += currentTime.minutes.toString().length < 2 ? "0" + currentTime.minutes.toString() : currentTime.minutes.toString();
			
			// Monta data, sempre ficando no formato dd/mm/yyyy
			_date = currentTime.date.toString().length < 2 ? "0" + currentTime.date.toString() : currentTime.date.toString();
			_date += "/";
			_date += (currentTime.month+1).toString().length < 2 ? "0" + (currentTime.month+1) : (currentTime.month+1);
			_date += "/"+currentTime.fullYear;
		}
		
		private function comecarContador():void
		{
			ticker = new Timer(_refreshTime,1);
			ticker.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
			ticker.start();
		}
		
		private function onTimerComplete(event:TimerEvent):void
		{
			atualizar();
			comecarContador();
		}
		
		[Inspectable(category="General", type="int", defaultValue="45000")]
		[Bindable]
		public function set refreshTime(ms:int):void
		{
			_refreshTime = ms;
		}
		
		public function get refreshTime():int
		{
			return _refreshTime;
		}
		
		[Inspectable(category="General", type="String", defaultValue="normal", enumeration="normal,normalLeft")]
		public function set position ( _position:String ) : void
		{
			// FIXME ver sobre o in, current state...
			if ( _position == "normal" || _position == "normalLeft")
			{
				this._position = _position;
			}
		}
		public function get position () : String
		{
			return _position;
		}
	}
}