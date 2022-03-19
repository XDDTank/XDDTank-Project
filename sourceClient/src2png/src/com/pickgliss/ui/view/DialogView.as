// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.view.DialogView

package com.pickgliss.ui.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.utils.Timer;
    import flash.text.TextField;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import com.pickgliss.utils.ClassUtils;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.utils.getDefinitionByName;
    import flash.text.TextFormat;
    import flash.filters.GlowFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.events.TimerEvent;
    import com.pickgliss.ui.DialogManagerBase;

    public class DialogView extends Sprite implements Disposeable 
    {

        private var _contentString:String;
        private var _animationTimer:Timer;
        private var _contentTxt:TextField;
        private var _dialogMc:Sprite;
        private var _headImgMc:Sprite;
        private var _headMc:MovieClip;
        private var _mouseBitmap:Bitmap;
        private var _showMouse:Boolean;

        public function DialogView()
        {
            this._dialogMc = new Sprite();
            this._headImgMc = new Sprite();
            var _local_1:BitmapData = (ClassUtils.CreatInstance("asset.dialog.mouse") as BitmapData);
            this._mouseBitmap = new Bitmap(_local_1);
            this._mouseBitmap.x = 825;
            this._mouseBitmap.y = 152;
            this.addChild(this._headImgMc);
            this.addChild(this._dialogMc);
            this.addEventListener(Event.ADDED_TO_STAGE, this.start);
        }

        public function setHeadImgIndex(index:String):void
        {
            var instanceClass:Object;
            var mask:Sprite = this.createHeadImgMask();
            try
            {
                instanceClass = getDefinitionByName(("asset.dialog.face" + index));
                this._headMc = (new (instanceClass)() as MovieClip);
            }
            catch(e:ReferenceError)
            {
            };
            if ((!(this._headMc)))
            {
                this._headMc = new MovieClip();
            };
            this._headMc.x = 85;
            this._headMc.y = 180;
            this._headImgMc.addChild(this._headMc);
            this._headImgMc.addChild(mask);
            this._headMc.mask = mask;
        }

        public function setName(_arg_1:String):void
        {
            var _local_2:TextField;
            _local_2 = new TextField();
            var _local_3:TextFormat = new TextFormat();
            _local_2.selectable = false;
            _local_2.mouseEnabled = false;
            _local_3.font = "Tahoma";
            _local_3.size = 16;
            _local_3.color = 16764006;
            _local_2.defaultTextFormat = _local_3;
            _local_2.width = 616;
            _local_2.height = 28;
            _local_2.x = 225;
            _local_2.y = 95;
            _local_2.text = (_arg_1 + "：");
            _local_2.filters = [new GlowFilter(0x3D1000, 1, 5, 5, 10, BitmapFilterQuality.LOW, false, false)];
            this._dialogMc.addChild(_local_2);
        }

        public function setContent(_arg_1:String, _arg_2:Boolean=true, _arg_3:uint=80):void
        {
            this._showMouse = _arg_2;
            this._contentTxt = new TextField();
            var _local_4:TextFormat = new TextFormat();
            this._contentTxt.selectable = false;
            this._contentTxt.mouseEnabled = false;
            this._contentTxt.multiline = true;
            this._contentTxt.wordWrap = true;
            _local_4.font = "Tahoma";
            _local_4.size = 16;
            _local_4.color = 0xFFFFFF;
            this._contentTxt.defaultTextFormat = _local_4;
            this._contentTxt.width = 445;
            this._contentTxt.height = 102;
            this._contentTxt.x = 0xFF;
            this._contentTxt.y = 126;
            this._dialogMc.addChild(this._contentTxt);
            this._contentString = _arg_1;
            this._animationTimer = new Timer(_arg_3, 0);
            this._animationTimer.addEventListener(TimerEvent.TIMER, this.showContent);
        }

        public function get headMc():MovieClip
        {
            return (this._headMc);
        }

        public function get isRunning():Boolean
        {
            if (this._animationTimer == null)
            {
                return (false);
            };
            return (this._animationTimer.running);
        }

        public function start(_arg_1:Event):void
        {
            if (this._animationTimer != null)
            {
                this._animationTimer.start();
            };
        }

        public function showAllContentString():void
        {
            this._contentTxt.text = this._contentString;
            this._animationTimer.stop();
            this._animationTimer = null;
            if (this._showMouse)
            {
                if ((!(this._mouseBitmap.parent)))
                {
                    addChild(this._mouseBitmap);
                };
            };
        }

        private function showContent(_arg_1:TimerEvent):void
        {
            if (this._animationTimer.currentCount <= this._contentString.length)
            {
                this._contentTxt.text = this._contentString.substr(0, this._animationTimer.currentCount);
            }
            else
            {
                this._animationTimer.stop();
                this._animationTimer = null;
                if (this._showMouse)
                {
                    if ((!(this._mouseBitmap.parent)))
                    {
                        addChild(this._mouseBitmap);
                    };
                };
            };
        }

        private function createHeadImgMask():Sprite
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(1, 1);
            _local_1.graphics.drawRect(0, 0, (DialogManagerBase.HEAD_IMG_WIDTH + 400), (DialogManagerBase.HEAD_IMG_HEIGHT + 185));
            _local_1.graphics.endFill();
            _local_1.x = -16;
            _local_1.y = -(DialogManagerBase.HEAD_IMG_HEIGHT);
            return (_local_1);
        }

        public function dispose():void
        {
            if (this._animationTimer)
            {
                this._animationTimer.stop();
                this._animationTimer = null;
            };
            while (this._dialogMc.numChildren > 0)
            {
                this._dialogMc.removeChildAt(0);
            };
            while (this._headImgMc.numChildren > 0)
            {
                this._headImgMc.removeChildAt(0);
            };
            if (this._mouseBitmap.parent)
            {
                removeChild(this._mouseBitmap);
            };
            this._mouseBitmap = null;
            this._headMc = null;
            this._contentTxt = null;
            this.removeChild(this._dialogMc);
            this.removeChild(this._headImgMc);
            this._dialogMc = null;
            this._headImgMc = null;
            this.parent.removeChild(this);
        }


    }
}//package com.pickgliss.ui.view

