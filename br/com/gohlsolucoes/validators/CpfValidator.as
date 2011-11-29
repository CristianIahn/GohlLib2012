package br.com.gohlsolucoes.validators
{
	import mx.collections.ArrayCollection;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class CpfValidator extends Validator
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function CpfValidator()
		{
			super();
		}
		
		//----------------------------------
		//  invalidError
		//----------------------------------
		/**
		 *  @private
		 */
		private var _invalidError:String = "CPF inválido!";
		
		[Inspectable(category="Errors", defaultValue="CPF inválido!")]
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
			var digito:Array = new Array(); // array para os dígitos do CPF.
			var aux:Number= 0;
			var posicao:Number;
			var i:Number;
			var soma:Number;
			var dv:Number;
			var dvInformado:Number;
			var cpf:String = value.text;
			
			// Retira os dígitos formatadores de CPF '.' e '-', caso existam.
			cpf = cpf.replace(".", "").replace(".", ""); // Só retirar duas vezes mesmo, pois se tirar todos, e inserir com masc, fica errado.
			cpf = cpf.replace("-", "");
			
			var manjados:ArrayCollection = new ArrayCollection( new Array('00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555', '66666666666', '77777777777', '88888888888', '99999999999') );
			
			// Veridica tamanho do CPF e CPFs manjados
			if ( cpf.length < 11 || manjados.contains(cpf) )
			{
				results.push(new ValidationResult( true, null, "Erro", _invalidError) );
				
				return results;
			}
			
			// Início da validação do CPF.
			
			/* Retira do número informado os dois últimos dígitos */
			
			dvInformado = parseInt(cpf.substr(9,2));
			
			/* Desmembra o número do CPF no array digito */
			for ( i = 0; i <= 8; i++)
			{
				digito[i] = cpf.substr(i,1);
			}
			
			/* Calcula o valor do 10o. digito de verificação */
			posicao = 10;
			soma = 0;
			
			for ( i = 0; i  <= 8; i++)
			{
				soma = soma + digito[i] * posicao;
				posicao--;
			}
			
			digito[9] = soma % 11;
			
			if (digito[9] < 2)
			{
				digito[9] = 0;
			}
				
			else
			{
				digito[9] = 11 - digito[9];
			}
			
			/* Calcula o valor do 11o. digito de verificação */
			posicao = 11;
			soma = 0;
			
			for ( i = 0; i <= 9; i++)
			{
				soma = soma + digito[i] * posicao;
				posicao--;
			}
			
			digito[10] = soma % 11;
			
			if (digito[10] < 2)
			{
				digito[10] = 0;
			}
				
			else
			{
				digito[10] = 11 - digito[10];
			}
			
			dv = digito[9] * 10 + digito[10];
			
			/* Verifica se o DV calculado é igual ao informado */
			if(dv != dvInformado)
			{
				results.push(new ValidationResult(true, null, "Erro", _invalidError));
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