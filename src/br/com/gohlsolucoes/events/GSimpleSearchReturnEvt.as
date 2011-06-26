package br.com.gohlsolucoes.events
{
    import flash.events.Event;
    
    public class GSimpleSearchReturnEvt extends Event
    {   
        public var objeto:Object = new Object;
        public function GSimpleSearchReturnEvt(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
        
    }
}