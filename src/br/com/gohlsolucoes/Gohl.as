/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes
{
	import br.com.gohlsolucoes.controls.GException;
	
	import spark.components.gridClasses.GridColumn;
	
	public class Gohl
	{
		private static var _instance:Gohl;
		
		public function Gohl(enforcer:SingletonEnforcer)
		{
			if(enforcer == null)
			{
				throw new GException("Só pode haver uma instância desta classe", "falha");
			}
		}
		
		public static function getInstance():Gohl
		{
			if (_instance == null)
			{
				_instance = new Gohl(new SingletonEnforcer());
			}
				
			return _instance;
		}
		
		public function createDiferencialString(comp:*):String
		{
			var data:Date = new Date();
			var sDiferencial:String = data.hours.toString() +
				data.minutes.toString() + 
				data.seconds.toString() +
				data.milliseconds.toString()+
				(comp.uid.charAt(comp.uid.length-2) + comp.uid.charAt(comp.uid.length-1)).toString();
			
			return sDiferencial;
		}
	}
}

class SingletonEnforcer {}