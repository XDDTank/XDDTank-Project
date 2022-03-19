// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.DungeonHelpView

package game.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import flash.utils.Timer;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import game.view.smallMap.GameTurnButton;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.greensock.TweenLite;
    import com.greensock.easing.Sine;
    import flash.events.TimerEvent;
    import game.GameManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;

    public class DungeonHelpView extends Sprite implements Disposeable 
    {

        private var _isFirst:Boolean;
        private var _closeBtn:SimpleBitmapButton;
        private var _time:Timer;
        private var _opened:Boolean;
        private var _container:Sprite;
        private var _winTxt1:FilterFrameText;
        private var _winTxt2:FilterFrameText;
        private var _lostTxt1:FilterFrameText;
        private var _lostTxt2:FilterFrameText;
        private var _arrow1:Bitmap;
        private var _arrow2:Bitmap;
        private var _arrow3:Bitmap;
        private var _arrow4:Bitmap;
        private var _tweened:Boolean = false;
        private var _turnButton:GameTurnButton;
        private var _gameContainer:DisplayObjectContainer;
        private var _barrier:DungeonInfoView;
        private var _sourceRect:Rectangle;
        private var _showed:Boolean = false;

        public function DungeonHelpView(_arg_1:GameTurnButton, _arg_2:DungeonInfoView, _arg_3:DisplayObjectContainer)
        {
            this._isFirst = true;
            buttonMode = false;
            mouseEnabled = false;
            this._turnButton = _arg_1;
            this._barrier = _arg_2;
            this._gameContainer = _arg_3;
            this._container = new Sprite();
            var _local_4:Bitmap = ComponentFactory.Instance.creatBitmap("asset.game.missionInfoBG2Asset");
            this._container.addChild(_local_4);
            this._container.x = 211;
            this._container.y = 65;
            addChild(this._container);
            this._winTxt1 = ComponentFactory.Instance.creat("asset.DungeonHelpView.winTxt1");
            this._container.addChild(this._winTxt1);
            this._winTxt2 = ComponentFactory.Instance.creat("asset.DungeonHelpView.winTxt2");
            this._container.addChild(this._winTxt2);
            this._lostTxt1 = ComponentFactory.Instance.creat("asset.DungeonHelpView.lostTxt1");
            this._container.addChild(this._lostTxt1);
            this._lostTxt2 = ComponentFactory.Instance.creat("asset.DungeonHelpView.lostTxt2");
            this._container.addChild(this._lostTxt2);
            this._closeBtn = ComponentFactory.Instance.creat("asset.game.DungeonHelpView.closeBtn");
            this._container.addChild(this._closeBtn);
            this._arrow1 = ComponentFactory.Instance.creat("asset.game.missionHelpArrow2");
            this._container.addChild(this._arrow1);
            this._arrow1.visible = false;
            this._arrow2 = ComponentFactory.Instance.creat("asset.game.missionHelpArrow2");
            this._container.addChild(this._arrow2);
            this._arrow2.visible = false;
            this._arrow3 = ComponentFactory.Instance.creat("asset.game.missionHelpArrow1");
            this._container.addChild(this._arrow3);
            this._arrow3.visible = false;
            this._arrow4 = ComponentFactory.Instance.creat("asset.game.missionHelpArrow1");
            this._container.addChild(this._arrow4);
            this._arrow4.visible = false;
            this.setText();
            this._sourceRect = new Rectangle(0, 0, 424, 132);
            this._sourceRect.x = ((StageReferance.stageWidth - this._sourceRect.width) >> 1);
            this._sourceRect.y = ((StageReferance.stageHeight - this._sourceRect.height) >> 1);
            addEventListener(MouseEvent.CLICK, this.__closeHandler);
            addEventListener(Event.ADDED_TO_STAGE, this.__startEffect);
        }

        private function closeComplete():void
        {
            if (parent)
            {
                parent.removeChild(this);
                if (this._isFirst)
                {
                    this._turnButton.isFirst = false;
                    this._turnButton.shine();
                    this._isFirst = false;
                };
            };
        }

        private function openComplete():void
        {
        }

        public function open():void
        {
            if (this._tweened)
            {
                TweenLite.killTweensOf(this._container, true);
            };
            this._gameContainer.addChild(this);
            this._tweened = true;
            this._opened = true;
            TweenLite.to(this, 0.3, {
                "x":this._sourceRect.x,
                "y":this._sourceRect.y,
                "width":this._sourceRect.width,
                "height":this._sourceRect.height,
                "ease":Sine.easeOut,
                "onComplete":this.openComplete
            });
            this._winTxt2.text = "";
            this._winTxt2.visible = false;
        }

        public function close(_arg_1:Rectangle):void
        {
            if (this._tweened)
            {
                TweenLite.killTweensOf(this, true);
            };
            this._tweened = true;
            this._opened = false;
            TweenLite.to(this, 0.6, {
                "width":_arg_1.width,
                "height":_arg_1.height,
                "x":_arg_1.x,
                "y":_arg_1.y,
                "ease":Sine.easeIn,
                "onComplete":this.closeComplete
            });
        }

        private function __sleepOrStop():void
        {
            if (this._isFirst)
            {
                this._time = new Timer(2000, 1);
                this._time.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                this._time.start();
                this._showed = true;
            };
        }

        private function __timerComplete(_arg_1:TimerEvent):void
        {
            var _local_2:Rectangle;
            if (((this._turnButton) && (this._gameContainer)))
            {
                _local_2 = this._turnButton.getBounds(this._gameContainer);
                _local_2.x = 860;
                _local_2.y = 5;
            };
            this.close(_local_2);
            this.clearTime();
        }

        private function clearTime():void
        {
            if (this._time)
            {
                this._time.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                this._time.stop();
            };
            this._time = null;
        }

        private function setText():void
        {
            var _local_2:Array;
            var _local_1:Array = GameManager.Instance.Current.missionInfo.success.split("<br>");
            _local_2 = GameManager.Instance.Current.missionInfo.failure.split("<br>");
            this._winTxt1.text = _local_1[0];
            this._arrow1.y = (this._winTxt1.y + 5);
            this._arrow1.x = (this._winTxt1.x - 15);
            this._arrow1.visible = true;
            if (_local_1.length >= 2)
            {
                this._winTxt2.text = _local_1[1];
                this._winTxt2.y = ((this._winTxt1.y + this._winTxt1.textHeight) + 25);
                this._arrow2.y = (this._winTxt2.y + 5);
                this._arrow2.x = (this._winTxt2.x - 15);
                this._arrow2.visible = true;
            }
            else
            {
                this._arrow2.visible = false;
            };
            this._lostTxt1.text = _local_2[0];
            this._arrow3.y = (this._lostTxt1.y + 5);
            this._arrow3.x = (this._lostTxt1.x - 15);
            this._arrow3.visible = true;
            if (_local_2.length >= 2)
            {
                this._lostTxt2.text = _local_2[1];
                this._lostTxt2.y = ((this._lostTxt1.y + this._lostTxt1.textHeight) + 25);
                this._arrow4.y = (this._lostTxt2.y + 5);
                this._arrow4.x = (this._lostTxt2.x - 15);
                this._arrow4.visible = true;
            }
            else
            {
                this._arrow4.visible = false;
            };
        }

        public function dispose():void
        {
            this.clearTime();
            if (this._tweened)
            {
                TweenLite.killTweensOf(this._container);
            };
            if (this._closeBtn)
            {
                this._closeBtn.removeEventListener(MouseEvent.CLICK, this.__closeHandler);
                ObjectUtils.disposeObject(this._closeBtn);
                this._closeBtn = null;
            };
            removeEventListener(MouseEvent.CLICK, this.__closeHandler);
            this._winTxt1.dispose();
            this._winTxt1 = null;
            this._winTxt2.dispose();
            this._winTxt2 = null;
            this._lostTxt1.dispose();
            this._lostTxt1 = null;
            this._lostTxt2.dispose();
            this._lostTxt2 = null;
            this._container.removeChild(this._arrow1);
            this._arrow1.bitmapData.dispose();
            this._arrow1 = null;
            this._container.removeChild(this._arrow2);
            this._arrow2.bitmapData.dispose();
            this._arrow2 = null;
            this._container.removeChild(this._arrow3);
            this._arrow3.bitmapData.dispose();
            this._arrow3 = null;
            this._container.removeChild(this._arrow4);
            this._arrow4.bitmapData.dispose();
            this._arrow4 = null;
            ObjectUtils.disposeAllChildren(this._container);
            if (this._container.parent)
            {
                removeChild(this._container);
            };
            this._container = null;
            this._turnButton = null;
            if (this._barrier)
            {
                this._barrier.dispose();
            };
            this._barrier = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        private function __startEffect(_arg_1:Event):void
        {
            this._opened = true;
            x = (StageReferance.stageWidth >> 1);
            y = (StageReferance.stageHeight >> 1);
            width = 1;
            height = 1;
            TweenLite.to(this, 1, {
                "x":this._sourceRect.x,
                "y":this._sourceRect.y,
                "width":this._sourceRect.width,
                "height":this._sourceRect.height,
                "ease":Sine.easeOut,
                "onComplete":this.__sleepOrStop
            });
        }

        private function __closeHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Rectangle;
            SoundManager.instance.play("008");
            if (this._isFirst)
            {
                this.close(new Rectangle(1000, 0, 2, 2));
            }
            else
            {
                _local_2 = this._barrier.getBounds(this._gameContainer);
                _local_2.width = (_local_2.height = 1);
                this.close(_local_2);
            };
            StageReferance.stage.focus = null;
        }

        public function get opened():Boolean
        {
            return (this._opened);
        }

        public function get showed():Boolean
        {
            return (this._showed);
        }


    }
}//package game.view

