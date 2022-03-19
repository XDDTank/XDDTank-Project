// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.FaceContainer

package ddt.view
{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.events.Event;
    import flash.events.TimerEvent;

    public class FaceContainer extends Sprite 
    {

        private var _face:MovieClip;
        private var _oldScale:int;
        private var _isActingExpression:Boolean;
        private var _nickName:TextField;
        private var _expressionID:int;

        public function FaceContainer(_arg_1:Boolean=false)
        {
            this.init();
        }

        public function get nickName():TextField
        {
            return (this._nickName);
        }

        public function get expressionID():int
        {
            return (this._expressionID);
        }

        public function set isShowNickName(_arg_1:Boolean):void
        {
            if (((_arg_1) && (!(this._face == null))))
            {
                this._nickName.y = ((this._face.y - 20) - (this._face.height / 2));
                this._nickName.x = (-(this._face.width) / 2);
                this._nickName.visible = true;
            }
            else
            {
                this._nickName.y = 0;
                this._nickName.x = 0;
                this._nickName.visible = false;
            };
        }

        public function get isActingExpression():Boolean
        {
            return (this._isActingExpression);
        }

        public function setNickName(_arg_1:String):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            this._nickName.text = (_arg_1 + ":");
            this.addChild(this._nickName);
            this._nickName.visible = false;
        }

        private function init():void
        {
            var _local_1:TextFormat = new TextFormat();
            _local_1.color = "0xff0000";
            this._nickName = new TextField();
            this._nickName.defaultTextFormat = _local_1;
        }

        private function __timerComplete(_arg_1:TimerEvent):void
        {
            this.clearFace();
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function clearFace():void
        {
            if (this._face != null)
            {
                if (this._face.parent)
                {
                    this._face.stop();
                    this._face.parent.removeChild(this._face);
                };
                this._face.removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
                this._face = null;
                this._nickName.visible = false;
            };
        }

        public function setFace(_arg_1:int):void
        {
            if (this._oldScale == 0)
            {
                this._oldScale = scaleX;
            };
            this.clearFace();
            this._face = FaceSource.getFaceById(_arg_1);
            this._expressionID = _arg_1;
            if (this._face != null)
            {
                this._isActingExpression = true;
                if (_arg_1 == 42)
                {
                    this._face.scaleX = (this.scaleX = 1);
                }
                else
                {
                    scaleX = this._oldScale;
                };
                this._face.addEventListener(Event.ENTER_FRAME, this.__enterFrame);
                addChild(this._face);
            };
        }

        public function doClearFace():void
        {
            this._isActingExpression = false;
            this.clearFace();
        }

        private function __enterFrame(_arg_1:Event):void
        {
            if (this._face.currentFrame >= this._face.totalFrames)
            {
                this._isActingExpression = false;
                this.clearFace();
            };
        }

        public function dispose():void
        {
            this.clearFace();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view

