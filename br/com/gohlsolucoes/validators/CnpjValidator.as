package br.com.gohlsolucoes.validators
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class CnpjValidator extends Validator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function CnpjValidator()
		{
			super();
		}
		
		//----------------------------------
		//  invalidError
		//----------------------------------
		/**
		 *  @private
		 */
		private var _invalidError:String = "CNPJ inválido!";
		
		[Inspectable(category="Errors", defaultValue="CNPJ inválido!")]
		public function set InvalidError(text:String):void
		{
			_invalidError = text;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		override protected function doValidation(value:Object):Array
		{
			var results:Array = super.doValidation(value.text);
			var a:Array = new Array();
			var b:Number = new Number;
			var i:Number;
			var x:Number;
			var y:Number;
			var c:Array = [6,5,4,3,2,9,8,7,6,5,4,3,2];
			var cnpj:String = value.text;
			
			// Retira os dígitos formatadores de CNPJ '.' e '-', caso existam.
			cnpj = cnpj.replace(".", "").replace(".", ""); // Só retirar duas vezes mesmo, pois se tirar todos, e inserir com masc, fica errado.
			cnpj = cnpj.replace("-", "");
			cnpj = cnpj.replace("/", "");
			
			// Verifica tamanho do cnpj
			if ( cnpj.length < 14 || cnpj == "00000000000" )
			{
				results.push(new ValidationResult( true, null, "Erro", _invalidError) );
				
				return results;
			}
			
			for (i=0; i < 12; i++)
			{
				a[i] = cnpj.charAt(i);
				b += a[i] * c[i+1];
			}
			
			a[12] = (x = b % 11) < 2 ? 0 : 11-x;
			
			b = 0;
			
			for (y=0; y < 13; y++) 
			{
				b += (a[y] * c[y]);
			}
			
			a[13] = (x = b % 11) < 2 ? 0 : 11-x;
			
			if ( (cnpj.charAt(12) != a[12]) || (cnpj.charAt(13) != a[13]) )
			{
				results.push( new ValidationResult(true, null, "Erro", _invalidError) );
			}
			
			return results;
		}
		
		override protected function getValueFromSource():Object
		{
			var value:Object = {};
			
			value.text = super.getValueFromSource();
			
			return  value;
		}
	}
}