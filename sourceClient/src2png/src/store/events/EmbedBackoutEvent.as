// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.events.EmbedBackoutEvent

package store.events
{
    import flash.events.Event;

    public class EmbedBackoutEvent extends Event 
    {

        public static const EMBED_BACKOUT:String = "embedBackout";
        public static const EMBED_BACKOUT_DOWNITEM_OVER:String = "embedBackoutDownItemOver";
        public static const EMBED_BACKOUT_DOWNITEM_OUT:String = "embedBackoutDownItemOut";
        public static const EMBED_BACKOUT_DOWNITEM_DOWN:String = "embedBackoutDownItemDown";

        private var _cellID:int;
        private var _templateID:int;

        public function EmbedBackoutEvent(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Boolean=false, _arg_5:Boolean=false)
        {
            super(_arg_1, _arg_4, _arg_5);
            this._cellID = _arg_2;
            this._templateID = _arg_3;
        }

        public function get CellID():int
        {
            return (this._cellID);
        }

        public function get TemplateID():int
        {
            return (this._templateID);
        }


    }
}//package store.events

