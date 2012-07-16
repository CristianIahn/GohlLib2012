/***************************************
 * 
 * GCollapsibleForm
 * 
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.gohlsolucoes.com.br
 * 
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.events.GStateChanged;
	import br.com.gohlsolucoes.skins.SGCollapsibleForm;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	import mx.states.State;
	
	import spark.components.Form;
	import spark.components.FormHeading;
	import spark.components.Label;
	import spark.components.Panel;
	import spark.core.IDisplayText;
	
	[Event(name="stateChanged", type="br.com.gohlsolucoes.events.GStateChanged")]
	[SkinState('normal', 'collapsed', 'error', 'disabled')]
	public class GCollapsibleForm extends Form
	{
		//----------------------------------
		//  Variáveis
		//----------------------------------
		
		//[Exclude(name="_title", kind="property")]
		//[Inspectable(environment="none", name="_title", verbose="1")]
		
		[SkinPart(required="true", type="br.com.gohlsolucoes.controls.GCollapsibleFormHeading")]
		[Bindable]
		public var gcFormHeading:GCollapsibleFormHeading = new GCollapsibleFormHeading;
		
		private var _collapsed:Boolean = false;
		
		//----------------------------------
		//  Construtor
		//----------------------------------
		
		public function GCollapsibleForm()
		{
			super();
			
			addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, onChangeState);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			states = [new State({name:"normal"}),
					  new State({name:"collapsed"}),
					  new State({name:"error"}),
					  new State({name:"disabled"})];
			
			setStyle('skinClass', br.com.gohlsolucoes.skins.SGCollapsibleForm);
		}
		
		//----------------------------------
		//  Parâmetros
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _title:String = "";
		
		/**
		 *  @private
		 */
		private var titleChanged:Boolean;
		
		[Bindable]
		[Inspectable(category="General", defaultValue="")]
		public function get title():String
		{
			return _title;
		}
		
		public function set title(title:String):void
		{
			_title = title;
			gcFormHeading.label = title;
		}
		
		[Inspectable(defaultValue="false", arrayType="Boolean", enumeration="false,true")]
		public function set collapsed(collapsed:Boolean):void
		{
			_collapsed = collapsed;
		}
		
		public function get collapsed():Boolean
		{
			return _collapsed;
		}
		
		/**
		 *  @private
		 */
		/*override public function get baselinePosition():Number
		{
			return getBaselinePositionForPart(titleTest as Label);
		} */
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == gcFormHeading)
			{
				gcFormHeading.label = title;
			}
		}
		
		//----------------------------------
		//  Eventos
		//----------------------------------
		
		protected function onChangeState(event:FlexEvent):void
		{
			var evt:GStateChanged = new GStateChanged(GStateChanged.STATE_CHANGED);
			evt.newState = currentState;
			dispatchEvent(evt);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			if ( _collapsed )
			{
				currentState = 'collapsed';
			}
		}
	}
}