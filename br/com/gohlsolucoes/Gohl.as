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
		private var usuario:*;
		
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
		
		public function setUsuario(usuario:*):void
		{
			this.usuario = usuario;
		}
		
		public function getUsuario():*
		{
			return this.usuario;
		}
		
		public function removeAccent(text:String):String
		{
			var withAccent:Array = new Array('á', 'é', 'í', 'ó', 'ú', 'Á', 'É', 'Í', 'Ó', 'Ú',
											 'â', 'ê', 'î', 'ô', 'û', 'Â', 'Ê', 'Î', 'Ô', 'Û',
											 'ã', 'õ', 'Ã', 'Õ',
											 'ç', 'Ç',
											 'ä', 'ë', 'ï', 'ö', 'ü', 'Ä', 'Ë', 'Ï', 'Ö', 'Ü',
											 'à', 'è', 'ì', 'ò', 'ù', 'À', 'È', 'Ì', 'Ò', 'Ù');
			var withoutAccent:Array = new Array('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U',
												'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U',
												'a', 'o', 'A', 'O',
												'c', 'C',
												'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U',
												'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U');
			
			for ( var i:int = 0; i < withAccent.length; i++ )
			{
				
				text = text.replace( new RegExp(withAccent[i], 'g'), withoutAccent[i] );
			}
			
			return text;
		}
	}
}

class SingletonEnforcer {}