/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes.validators
{
	import mx.validators.StringValidator;
	
	public class GStringValidator extends StringValidator
	{
		public function GStringValidator()
		{
			super();
		}
		
		/**
		 * Função para validar de forma mais rápida, e aceitando diretamente String.
		 * <p><code>GStringValidator.validateNow("string", "name")</code>.</p>
		 * @param source:* - Pode ser objeto ou string
		 * @param name:String - Nome da propriedade
		 * @param property:String - Propriedade a ser acessada.
		 * @param errorMessage:String - Mensagem de erro, utilizar % para o nome. 
		 * @return errorMessage:String - Caso tenha erro substitui o % pelo nome, caso  não retorna "".
		 * 
		 */		
		public static function validateNow(source:*, name:String, property:String = "String", errorMessage:String = "% não definido"):String
		{
			var message:String = "";
			var validator:GStringValidator = new GStringValidator;
			
			var validObject:Object;
			if (property == "String")
			{
				validObject = new Object;
				validObject.text = source;
				validator.source = validObject;
				validator.property = "text";
			}
			else
			{
				validator.source = source;
				validator.property = property;
			}
			
			validator.required = true;
			
			message = validator.validate().type == "invalid" ? errorMessage.replace("%", name) : "";
			
			return message;
		}
	}
}