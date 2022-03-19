// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.action.ShowTipAction

package com.pickgliss.action
{
    import flash.display.MovieClip;
    import flash.events.EventDispatcher;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ComponentSetting;
    import com.pickgliss.ui.LayerManager;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class ShowTipAction extends BaseAction 
    {

        private var _tip:MovieClip;
        private var _sound:String;
        private var _dispatcher:EventDispatcher;

        public function ShowTipAction(_arg_1:DisplayObject, _arg_2:String=null)
        {
            this._tip = (_arg_1 as MovieClip);
            this._sound = _arg_2;
        }

        override public function act():void
        {
            if (((this._sound) && (ComponentSetting.PLAY_SOUND_FUNC is Function)))
            {
                ComponentSetting.PLAY_SOUND_FUNC(this._sound);
            };
            LayerManager.Instance.addToLayer(this._tip, LayerManager.GAME_TOP_LAYER, false, LayerManager.NONE_BLOCKGOUND, false);
            this._tip.addEventListener(Event.ENTER_FRAME, this.__frameHandler);
            this._tip.addEventListener(MouseEvent.CLICK, this.__newQuestClickHandler);
            this._tip.play();
        }

        private function __frameHandler(_arg_1:Event):void
        {
            if (this._tip)
            {
                if (this._tip.currentFrame == this._tip.totalFrames)
                {
                    this._tip.removeEventListener(Event.ENTER_FRAME, this.__frameHandler);
                    this._tip.stop();
                    this._tip.parent.removeChild(this._tip);
                    this._tip = null;
                };
            };
        }

        private function __newQuestClickHandler(_arg_1:MouseEvent):void
        {
            this._dispatcher.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        }

        public function get dispatcher():EventDispatcher
        {
            return (this._dispatcher);
        }

        public function dispose():void
        {
            this._dispatcher = null;
            if (this._tip)
            {
                this._tip.removeEventListener(Event.ENTER_FRAME, this.__frameHandler);
                this._tip.stop();
                this._tip.parent.removeChild(this._tip);
                this._tip = null;
            };
        }


    }
}//package com.pickgliss.action

