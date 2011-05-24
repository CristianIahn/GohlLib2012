/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl [cristian.gohl@live.com]
 * http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes.controls
{
	public class GException
	{
		/* Guarda mensagem da exeção */
		private var _menssagem:String;
		
		/* Guarda o tipo de exeção */
		private var _tipo:String;
		
		/**
		 * Retorna a mensagem da exeção.
		 * @return mensagem:String
		 */
		public function get mensagem():String
		{
			return _menssagem;
		}
		
		/**
		 * Retorna o tipo da exeção. 
		 * @return tipo:String
		 */
		public function get tipo():String
		{
			return _tipo;
		}
		
		/**
		 * Função para exeção. 
		 * @param mensagem:String - Recebe a mensagem da exeção.
		 * @param tipo:String - Recebe o tipo da exeção, ou usa padrão falha.
		 */		
		public function GException(mensagem:String, tipo:String = "falha" )
		{
			_menssagem = mensagem;
			_tipo = tipo;
		}
	}
}