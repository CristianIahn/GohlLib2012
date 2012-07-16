/***************************************
 * 
 * GMaskedTextInput
 * 
 * Projeto: GohlLib
 * Copyright (c) 2011
 * @author Cristian Edson Göhl
 * @link http://www.gohlsolucoes.com.br
 * 
 * Gambiarra Master Mode = ON;
 ****************************************/

package br.com.gohlsolucoes.controls
{
	import br.com.gohlsolucoes.controls.GAlert;
	import br.com.gohlsolucoes.controls.GButton;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.SkinnableContainer;
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	public class GMaskedTextInput extends SkinnableContainer
	{
		//----------------------------------
		//  Variáveis
		//----------------------------------
		/**
		 * @private
		 * Text Input utilizado para construir o GSearchTextInput
		 */
		private var mti:TextInput;
		
		/**
		 * @private
		 */
		private var _inputMask:String;
		
		private var _pureText:String = "";
		
		private var _totalBlankChar:int = 0;
		
		private var _blankPosition:ArrayCollection = new ArrayCollection;
		
		private var _incompleteError:String = "Preencha todo o campo!";
		/**
		 * @private
		 */
		private var clearButton:GButton;
		
		[Embed("../assets/p16/limpar.png")] // [Embed(source="../assets/p16/buscar.png")] Diferença??
		protected const CLEAR_ICON:Class;
		
		protected const BLANK:String = "_";
		
		//----------------------------------
		//  Construtor
		//----------------------------------
		
		public function GMaskedTextInput()
		{
			super();
			
			attachEventListeners();
			
			createMti();
			
			// Para receber focus no textinput.
			//this.hasFocusableChildren = true;
		}
		
		[Inspectable(arrayType="String", category="Common")]
		//----------------------------------
		//  prompt
		//----------------------------------
		public function set prompt(prompt:String):void
		{
			mti.prompt = prompt;
		}
		
		public function get prompt():String
		{
			return mti.prompt;
		}
		
		//----------------------------------
		//  text
		//----------------------------------
		/**
		 * Retorna o texto que está aparecendo no componente.
		 * 
		 * Para o texto puro, sem mascara.
		 * <code>pureText</code>
		 */
		public function get text():String
		{
			return mti.text;
		}
		
		public function set text(text:String):void
		{
			if ( text != null )
			{
				this.errorString = '';
				if ( text != '' )
				{
					makeText('');
				}
				else
				{
					mti.text = '';
					this.clearButton.visible = false;
				}
				
				writePhrase(text);
			}
		}
		
		//----------------------------------
		//  pureText
		//----------------------------------
		public function get pureText():String
		{
			var text:String = "";
			for each ( var pos:int in _blankPosition )
			{
				text += mti.text.charAt(pos) != BLANK ? mti.text.charAt(pos) : '';
			}
			
			return text;
		}
		
		//----------------------------------
		//  incompleteError
		//----------------------------------
		public function set incompleteError(error:String):void
		{
			_incompleteError = error;
		}
		
		//----------------------------------
		//  inputMask
		//----------------------------------
		public function set inputMask(mask:String):void
		{
			_inputMask = mask;
		}
		
		public function get inputMask():String
		{
			return _inputMask;
		}
		
		
		//----------------------------------
		//  Funções
		//----------------------------------
		protected function createMti():void
		{
			mti = new TextInput;
			
			/* Seta tamanho */
			mti.percentHeight = 100;
			mti.percentWidth = 100;
			
			/* posição */
			mti.verticalCenter = 0;
			mti.horizontalCenter = 0;
			
			attachMtiEventListeners();
			
			this.addElement(mti);
		}
		
		protected function addClearButton():void
		{
			clearButton = new GButton("", CLEAR_ICON, "left", 16, 0, null, false);
			clearButton.right = 1.5;
			clearButton.top = 2;
			clearButton.bottom = 2;
			clearButton.verticalCenter = 0;
			clearButton.visible = false;
			clearButton.toolTip = "Limpar";
			clearButton.addEventListener(MouseEvent.CLICK, clearButton_clickHandler);
			
			this.addElement(clearButton);
		}
		
		/**
		 * Adiciona escutas de evento para o componente em geral.
		 */
		protected function attachEventListeners():void
		{
			//this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		/**
		 * Adiciona escutas de evento para o Mti.
		 */
		protected function attachMtiEventListeners():void
		{
			mti.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteMti);
			mti.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownMti);
			mti.addEventListener(TextOperationEvent.CHANGING, onChangingMti);
			mti.addEventListener(FocusEvent.FOCUS_IN, onFocusMti);
			mti.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutMti);
			mti.addEventListener(TextEvent.TEXT_INPUT, onTextInputMti);
			mti.addEventListener(Event.PASTE, onPasteMti);
			mti.addEventListener(Event.COPY, onCopyMti);
		}
		
		/**
		 * Troca os botões, buscar por limpar, alterando a visibilidade.
		 */
		protected function enableClear():void
		{
			this.clearButton.visible = true;
		}
		
		/**
		 * Responsável pela limpeza do formulário e também por deixar o botão de busca aparecendo,
		 * e o de limpeza invisível.
		 */
		public function clear():void
		{
			this.errorString = '';
			
			// Verifica se o focus está no MTI.
			if( focusManager.getFocus() == mti )
			{
				makeText('');
				setCorrectSelectionPosition();
			}
			else
			{
				mti.text = '';
			}
			
			this.clearButton.visible = false;
			
			/* Dispara evento clear */
			dispatchEvent(new Event(Event.CLEAR));
		}
		
		//----------------------------------
		//  Eventos
		//----------------------------------
		/**
		 * @private
		 * Função executada antes da alteração do texto visualmente(utilizando componente).
		 * Previne a digitação, podendo somente ser setado o texto internamente.
		 */
		private function onChangingMti(event:TextOperationEvent):void
		{
			event.preventDefault();
		}
		
		private function onFocusMti(event:FocusEvent):void
		{
			if ( mti.text == '' )
			{
				makeText('');
			}
			
			setCorrectSelectionPosition();
		}
		
		private function onFocusOutMti(event:FocusEvent):void
		{
			this.errorString = '';
			var blankNumber:int = 0;
			for ( var i:int = 0; i < mti.text.length; i++)
			{
				if ( mti.text.charAt(i) == BLANK )
				{
					blankNumber++;
				}
			}
			
			if ( blankNumber >= _totalBlankChar )
			{
				mti.text = '';
			}
			else if ( blankNumber != 0  )
			{
				this.errorString = _incompleteError;
			}
		}
		
		private function write(char:String):Boolean
		{
			var wrote:Boolean = false;
			
			for ( var c:int = 0; c < mti.text.length; c++)
			{
				// Assim escreve no primeiro em branco;
				if ( mti.text.charAt(c) == BLANK )
				{
					var type:String = inputMask.charAt(c);
					
					if ( type == "#" )
					{
						if ( ! isNaN(parseInt(char) ) )
						{
							mti.text = mti.text.replace(BLANK, char);
							wrote = true;
						}
					}
					else if ( type == "C" )
					{
						if ( isNaN(parseInt(char)) && char != " " )
						{
							mti.text = mti.text.replace(BLANK, char.toLocaleUpperCase());
							wrote = true;
						}
					}
					break; // depois que escreveu na primeira posição livre, pula fora do for.
				}
			}
			setCorrectSelectionPosition();
			
			return wrote;
		}
		
		private function writePhrase(phrase:String):void
		{
			var maxPastePos:int = _blankPosition.length;
			for ( var j:int = 0; j < maxPastePos; j++ )
			{
				if ( phrase.length > j )
				{
					var wrote:Boolean = write(phrase.charAt(j));
					if (!wrote)
					{
						maxPastePos++;
					}
				}
				else
				{
					break;
				}
			}
		}
		
		private function onTextInputMti(event:TextEvent):void
		{
			write(event.text);
		}
		
		private function onPasteMti(event:Event):void
		{
			if( Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT) )
			{
				var text:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT).toString();
				
				writePhrase(text);
			}
			
		}
		
		private function onCopyMti(event:Event):void
		{
			var textToCopy:String = mti.text.substring(mti.selectionAnchorPosition, mti.selectionActivePosition);
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, textToCopy, false);
		}
			
		
		// Desempenho ruim.
		private function setCorrectSelectionPosition():void
		{
			//mti.selectRange(mti.selectionActivePosition+1, mti.selectionActivePosition+1);
			
			var blankNumber:int = 0;
			for ( var i:int = 0; i < mti.text.length; i++)
			{
				if ( mti.text.charAt(i) == BLANK )
				{
					blankNumber++;
					//trace('setaRange = ' + i);
					mti.selectRange(i, i);
					//trace(mti.text.charAt(i));
					break;
				}
			}
			
			if ( blankNumber == 0 )
			{
				enableClear();
			}
			
			//trace(blankNumber);
			//trace(_pureText.length);
		}
		
		private function makeText(text:String):void
		{
			mti.text = inputMask.replace(/#|C/g, BLANK);
		}
		
		/**
		 * @private
		 * Adiciona os botões de busca e limpeza.
		 * Verifica se tem coluna setada, caso não tenha obtem as padrões.
		 */
		private function onCreationCompleteMti(event:FlexEvent):void
		{
			// Gambiarra para o focus.
			mti.tabIndex = this.tabIndex;
			
			addClearButton();
			
			_totalBlankChar = 0;
			_blankPosition.removeAll();
			for ( var i:int = 0; i < inputMask.length; i++)
			{
				if ( inputMask.charAt(i) == "#" || inputMask.charAt(i) == "C" )
				{
					_blankPosition.addItem(i);
					_totalBlankChar++;
				}
			}
		}
		
		/**
		 * @private
		 * Função responsável por limpar o componente ou abrir a busca.
		 */
		private function onKeyDownMti(event:KeyboardEvent):void
		{
			var keyPressed:uint = event.keyCode;
			if ( event.keyCode == Keyboard.ESCAPE )
			{
				clear();
			}
			else if ( event.keyCode == Keyboard.BACKSPACE || event.keyCode == Keyboard.DELETE )
			{
				if ( mti.selectionActivePosition > 0 && mti.selectionActivePosition == mti.selectionAnchorPosition)
				{
					if ( _blankPosition.contains(mti.selectionActivePosition-1) )
					{
						mti.text = setCharAt(mti.text, BLANK, mti.selectionActivePosition-1);
					}
					else
					{
						// percorre para encontrar o próximo caractére que pode ser apagado.
						for ( var i:int = mti.selectionActivePosition-2; i >= 0; i--)
						{
							if ( _blankPosition.contains(i) )
							{
								mti.text = setCharAt(mti.text, BLANK, i);
								break;
							}
						}
					}
					
				}
				else if ( mti.selectionAnchorPosition > 0 || mti.selectionActivePosition > 0 )
				{
					var lastPos:int = 0;
					var firstPos:int = 0;
					
					if ( mti.selectionAnchorPosition > mti.selectionActivePosition )
					{
						lastPos = mti.selectionAnchorPosition;
						firstPos = mti.selectionActivePosition;
					}
					else
					{
						lastPos = mti.selectionActivePosition;
						firstPos = mti.selectionAnchorPosition;
					}
					
					for ( var a:int = lastPos; a > firstPos; a -- )
					{
						if ( _blankPosition.contains(a-1) )
						{
							mti.text = setCharAt(mti.text, BLANK, a-1);
						}
					}
					
				}
					
				setCorrectSelectionPosition();
				
				var blankNumber:int = 0;
				for ( var m:int = 0; m < mti.text.length; m++)
				{
					if ( mti.text.charAt(m) == BLANK )
					{
						blankNumber++;
					}
				}
				
				if ( blankNumber >= _totalBlankChar )
				{
					this.clearButton.visible = false;
				}
			}
		}
		
		private function setCharAt(str:String, char:String,index:int):String
		{
			return str.substr(0,index) + char + str.substr(index + 1);
		}
		
		protected function clearButton_clickHandler(event:MouseEvent):void
		{
			clear();
		}
	}
}