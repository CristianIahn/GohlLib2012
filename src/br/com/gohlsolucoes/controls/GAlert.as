/***************************************
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.kiveo.com.br
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.events.GAlertEvt;
	import br.com.gohlsolucoes.skins.SGAlert;
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Image;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 *  GAlert é uma pop-up, com states pré-determinados(alerta,sucesso,falha,pergunta,personalizado).
	 *  Ela pode receber uma mensagem, tem imagens determinadas para (alerta,sucesso,falha e pergunta).
	 *  Todos os states tem o botão de fechar, o state de pergunta conta com botões Sim e Não,
	 *  os quais são utilizados para algum questionamento.
	 *
	 *  <p>Utilize chamada statica <code>add()</code> no ActionScript para adicionar um GAlert.</p>
	 *
	 *  <p>Para state alerta e personalizado o GAlert sera fechado automaticamente em 30 segundos,
	 *  para os demais em 10 segundos, salvo quando existir closeFunction, o mesmo não sera fechado automaticamente.</p>
	 */
	public class GAlert extends SkinnableComponent
	{
		/* Armazena função de close */
		private var _closeFunction:Function = null;
		
		/* Armazena resposta */
		private var _resposta:Boolean = false;
		
		/* Armazena mensagem */
		private var _mensagem:String = "";
		
		/* Armazena state do componente */
		private var _state:String = "sucesso";
		
		/* Armazena imagem para state personalizado */
		private var _imagem:Image = null;
		
		/* Armazena tooltip para imagem */
		private var _imagemToolTip:String = "";
		
		/* Armazena título para state personalizado */
		private var _titulo:String = "";
		
		/**
		 * @return(String) título para state personalizado.
		 */		
		public function get titulo () : String
		{
			return _titulo;
		}
		
		/**
		 *  Seta título para state personalizado.
		 * @param _titulo(String)
		 */		
		public function set titulo ( _titulo : String ) : void
		{
			this._titulo = _titulo;
		}
		
		/**
		 * @return (String) - tooltipo da imagem.
		 */		
		public function get imagemToolTip () : String
		{
			return _imagemToolTip;
		}
		
		/**
		 * Seta tooltip da imagem. 
		 * @param _imagemToolTip(String)
		 */		
		public function set imagemToolTip ( _imagemToolTip : String ) : void
		{
			this._imagemToolTip = _imagemToolTip;
		}
		
		/**
		 * @return(Image) imagem para state personalizado.
		 */		
		public function get imagem () : Image
		{
			return _imagem;
		}
		
		/**
		 * Seta imagem para state personalizado. 
		 * @param _imagem(Image)
		 */		
		public function set imagem ( _imagem:Image ) : void
		{
			this._imagem = _imagem;
		}
		
		/**
		 * @return(String) mensagem 
		 */
		public function get mensagem () : String
		{
			return this._mensagem;
		}
		
		/**
		 * Seta mensagem do GAlert. 
		 * @param _mensagem(String)
		 */
		public function set mensagem ( _mensagem:String ) : void
		{
			this._mensagem = _mensagem;
		}
		
		/**
		 * @return State(String) 
		 */		
		public function get State () : String
		{
			return _state;
		}
		
		/**
		 * Seta state do GAlert.
		 * @param _state(String) : sucesso|falha|alerta|pergunta
		 */
		[Inspectable(category="Layout Constraints", type="String", defaultValue="sucesso", enumeration="sucesso,falha,alerta,pergunta,personalizado")]
		[Bindable]
		public function set State ( _state:String ) : void
		{
			if ( _state == "sucesso" || _state == "falha" || _state == "alerta" || _state == "pergunta" || _state == "personalizado" )
			{
				this._state = _state;
			}
		}
		
		/**
		 * @param _closeFunction(Function)
		 */		
		public function set closeFunction ( _closeFunction : Function ) : void
		{
			this._closeFunction = _closeFunction;
		}
		
		/**
		 * @param _resposta(Boolean)
		 */		
		public function set resposta ( _resposta:Boolean ) : void
		{
			this._resposta = _resposta;
			close();
		}
		
		public function GAlert()
		{
			/* Seta os states */
			this.states = new Array ( "sucesso", "falha", "alerta", "pergunta", "personalizado" );
			
			/* Seta a classe de skin */
			this.setStyle( "skinClass", br.com.gohlsolucoes.skins.SGAlert );
			
			/* Adiciona escuta de creationComplete */
			this.addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete );
		}
		
		public function close() : void
		{
			PopUpManager.removePopUp(this);
		}
		
		/** FIXME corrigir isto de ter que recriar evento, fazer entender direto que é pra chamar este evento no REMOVED */
		private function remove(event:FlexEvent):void
		{
			this.addEventListener("retorno" , _closeFunction);
			
			var evt : GAlertEvt = new GAlertEvt("retorno");
			evt.resposta = this._resposta;
			this.dispatchEvent(evt);
		}
		
		private function onCreationComplete ( event:FlexEvent ) : void
		{
			/* Calcula a posição */
			var x:int = (FlexGlobals.topLevelApplication.width - this.width);
			var y:int = (FlexGlobals.topLevelApplication.height - this.height);

			if ( this._state == "alerta" || this._state == "pergunta" || this._state == "personalizado" )
			{
				/* Centraliza */
				this.move(x/2, y/2);
			}
			else
			{
				/* Move */
				this.move(x,y);
			}
			
			/* Se existe função de retorno(fechar) */
			if ( this._closeFunction != null )
			{
				this.addEventListener(FlexEvent.REMOVE, remove);
			}
			else if ( this._state == "alerta" || this._state == "personalizado" )
			{
				/* Adiciona contador de 30 segundos */
				var contador:Timer = new Timer(30000, 1);
				contador.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				contador.start();
			}
			else
			{
				/* Adiciona contador de 10 segundos */
				var contador2:Timer = new Timer(10000, 1);
				contador2.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				contador2.start();
			}
		}
		
		private function onTimerComplete ( event:TimerEvent ) : void
		{
			close();
		}
		
		/**
		 * Adiciona GAlert, somente o personalizado não tem imagem padrão.
		 * @param state(String) alerta|sucesso|falha|pergunta|personalizado
		 * @param mensagem(String)
		 * @param closeFunction(function)
		 * @param imagem(Image)
		 * @param imagemToolTipo(String)
		 */
		public static function add ( mensagem:String, state:String = "alerta", closeFunction:Function = null, titulo:String = "" , imagem:Image = null, imagemToolTip:String = "" ) :void
		{
			var alerta:GAlert = new GAlert;
			alerta.bottom = 0;
			alerta.right = 0;
			alerta.mensagem = mensagem;
			alerta.closeFunction = closeFunction;
			alerta.State = state;
			alerta.titulo = titulo;
			alerta.imagem = imagem;
			alerta.imagemToolTip = imagemToolTip;
			var modal:Boolean = state == "alerta" || state == "pergunta" || state == "personalizado" ? true : false;
			PopUpManager.addPopUp(alerta, FlexGlobals.topLevelApplication as DisplayObject, modal);
		}
	}
}