// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.CheckCodeFrame

package ddt.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.utils.Timer;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.Sprite;
    import flash.text.TextFieldType;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import flash.utils.getTimer;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import ddt.data.CheckCodeData;
    import flash.events.TimerEvent;
    import ddt.utils.FilterWordManager;
    import ddt.manager.StateManager;
    import com.pickgliss.ui.LayerManager;
    import flash.events.KeyboardEvent;
    import ddt.manager.SocketManager;
    import flash.ui.Keyboard;

    public class CheckCodeFrame extends BaseAlerFrame 
    {

        private static var _instance:CheckCodeFrame;

        private const BACK_GOUND_GAPE:int = 3;

        private var _time:int;
        private var _bgI:Bitmap;
        private var _bgII:Bitmap;
        private var _isShowed:Boolean = true;
        private var _inputArr:Array;
        private var _input:String;
        private var _countDownTxt:FilterFrameText;
        private var _secondTxt:FilterFrameText;
        private var coutTimer:Timer;
        private var coutTimer_1:Timer;
        private var checkCount:int = 0;
        private var _alertInfo:AlertInfo;
        private var okBtn:BaseButton;
        private var clearBtn:BaseButton;
        private var _numberArr:Array;
        private var _numViewArr:Array;
        private var _NOBtnIsOver:Boolean = false;
        private var _cheatTime:uint = 0;
        private var speed:Number = 10;
        private var currentPic:Bitmap;
        private var _showTimer:Timer = new Timer(1000);
        private var count:int;

        public function CheckCodeFrame()
        {
            super();
            try
            {
                this.initCheckCodeFrame();
            }
            catch(e:Error)
            {
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, __LoadCore2Complete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR, __LoadCore2Error);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_COREII);
            };
        }

        public static function get Instance():CheckCodeFrame
        {
            if (_instance == null)
            {
                _instance = ComponentFactory.Instance.creatCustomObject("core.checkCodeFrame");
            };
            return (_instance);
        }


        private function __LoadCore2Complete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDT_COREII)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__LoadCore2Complete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, this.__LoadCore2Error);
                this.initCheckCodeFrame();
            };
        }

        private function __LoadCore2Error(_arg_1:UIModuleEvent):void
        {
        }

        private function initCheckCodeFrame():void
        {
            var _local_2:int;
            var _local_3:FilterFrameText;
            var _local_4:BaseButton;
            var _local_5:ScaleFrameImage;
            var _local_6:Bitmap;
            var _local_7:Object;
            var _local_8:Sprite;
            this._bgI = ComponentFactory.Instance.creatBitmap("asset.core.checkCodeBgAsset");
            addToContent(this._bgI);
            this._bgII = ComponentFactory.Instance.creatBitmap("asset.core.checkCodeBgAssetI");
            addToContent(this._bgII);
            this._inputArr = new Array();
            var _local_1:int;
            while (_local_1 < 4)
            {
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeInputTxt");
                _local_3.type = TextFieldType.DYNAMIC;
                _local_3.text = "*";
                _local_3.x = (_local_3.x + (_local_1 * 48));
                this._inputArr.push(_local_3);
                _local_3.visible = false;
                addToContent(_local_3);
                _local_1++;
            };
            cancelButtonStyle = "core.Cancelbt";
            submitButtonStyle = "core.simplebt";
            this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.enthrallCheckFrame.checkCode"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("clear"));
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this.okBtn = _submitButton;
            this.okBtn.addEventListener(MouseEvent.CLICK, this.__okBtnClick);
            this.okBtn.enable = false;
            this.clearBtn = _cancelButton;
            this.clearBtn.addEventListener(MouseEvent.CLICK, this.__clearBtnClick);
            this.clearBtn.enable = false;
            this._countDownTxt = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeCountDownTxt");
            addToContent(this._countDownTxt);
            this._secondTxt = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeSecTxt");
            addToContent(this._secondTxt);
            this._secondTxt.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second");
            this._numberArr = new Array();
            this._numViewArr = new Array();
            while (_local_2 < 10)
            {
                _local_4 = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeNOBtn");
                _local_5 = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeNOBtnBg");
                _local_4.backgound = _local_5;
                _local_6 = ComponentFactory.Instance.creatBitmap((("asset.core.checkCodeNO" + String(_local_2)) + "Asset"));
                _local_6.x = ((_local_4.width - _local_6.width) / 2);
                _local_6.y = ((_local_4.height - _local_6.height) / 2);
                _local_4.addChild(_local_6);
                _local_7 = new Object();
                _local_8 = new Sprite();
                _local_4.x = (-(_local_4.width) / 2);
                _local_4.y = (-(_local_4.height) / 2);
                _local_8.addChild(_local_4);
                _local_7.view = _local_8;
                _local_7.NOView = _local_6;
                _local_7.id = _local_2;
                _local_7.angle = (_local_2 * 0.628);
                _local_7.axisZ = 100;
                this._numberArr.push(_local_7);
                this._numViewArr.push(_local_8);
                addToContent(_local_8);
                _local_8.addEventListener(MouseEvent.CLICK, this.clicknumSp);
                _local_8.addEventListener(MouseEvent.MOUSE_OVER, this.overnumSp);
                _local_8.addEventListener(MouseEvent.MOUSE_OUT, this.outnumSp);
                _local_2++;
            };
            this.setnumViewCoord();
        }

        public function get time():int
        {
            return (this._time);
        }

        public function set time(_arg_1:int):void
        {
            this._time = _arg_1;
        }

        private function clicknumSp(_arg_1:MouseEvent):void
        {
            if (this._cheatTime == 0)
            {
                this._cheatTime = getTimer();
            };
            SoundManager.instance.play("008");
            if (this._input.length >= 4)
            {
                return;
            };
            this._input = (this._input + String(this._numViewArr.indexOf(_arg_1.currentTarget)));
            this.textChange();
        }

        private function overnumSp(_arg_1:MouseEvent):void
        {
            this._NOBtnIsOver = true;
        }

        private function outnumSp(_arg_1:MouseEvent):void
        {
            this._NOBtnIsOver = false;
        }

        private function setnumViewCoord():void
        {
        }

        private function math_z(_arg_1:Object):void
        {
        }

        private function inFrameStart(_arg_1:Event):void
        {
            var _local_2:int = Math.abs((Math.sqrt((((mouseX - 356) * (mouseX - 356)) + ((mouseY - 166) * (mouseY - 166)))) - 100));
            if (_local_2 <= 100)
            {
                this.speed = (_local_2 / 200);
            };
            if (_local_2 > 100)
            {
                this.speed = 0.5;
            };
            if (this._NOBtnIsOver == true)
            {
                this.speed = 0.02;
            };
            var _local_3:int;
            while (_local_3 < this._numberArr.length)
            {
                this._numberArr[_local_3].NOView.visible = true;
                if (this._NOBtnIsOver)
                {
                    this._numberArr[_local_3].NOView.visible = false;
                };
                this._numberArr[_local_3].angle = (this._numberArr[_local_3].angle + (this.speed * 0.1));
                this._numberArr[_local_3].view.y = ((this._numberArr[_local_3].axisZ * Math.cos(this._numberArr[_local_3].angle)) + 166);
                this._numberArr[_local_3].view.x = ((this._numberArr[_local_3].axisZ * Math.sin(this._numberArr[_local_3].angle)) + 356);
                _local_3++;
            };
        }

        public function set data(_arg_1:CheckCodeData):void
        {
            if (((this.currentPic) && (this.currentPic.parent)))
            {
                removeChild(this.currentPic);
                this.currentPic.bitmapData.dispose();
                this.currentPic = null;
            };
            this.currentPic = _arg_1.pic;
            this.currentPic.width = (170 - (2 * this.BACK_GOUND_GAPE));
            this.currentPic.height = (75 - (2 * this.BACK_GOUND_GAPE));
            this.currentPic.x = (33 + ((Math.random() * 2) * this.BACK_GOUND_GAPE));
            this.currentPic.y = (143 + ((Math.random() * 2) * this.BACK_GOUND_GAPE));
            addChild(this.currentPic);
        }

        private function __onTimeComplete(_arg_1:TimerEvent):void
        {
            this._input = "";
            this.coutTimer.stop();
            this.coutTimer.reset();
            this.sendSelected();
        }

        private function __onTimeComplete_1(_arg_1:TimerEvent):void
        {
            this._countDownTxt.text = (int(this._countDownTxt.text) - 1).toString();
        }

        private function textChange():void
        {
            this.okBtn.enable = this.isValidText();
            this.clearBtn.enable = this.haveValidText();
            var _local_1:int;
            while (_local_1 < this._inputArr.length)
            {
                this._inputArr[_local_1].visible = false;
                if (_local_1 < this._input.length)
                {
                    this._inputArr[_local_1].visible = true;
                };
                _local_1++;
            };
        }

        private function haveValidText():Boolean
        {
            if (this._input.length == 0)
            {
                return (false);
            };
            return (true);
        }

        private function isValidText():Boolean
        {
            if (FilterWordManager.IsNullorEmpty(this._input))
            {
                return (false);
            };
            if (this._input.length != 4)
            {
                return (false);
            };
            return (true);
        }

        public function set tip(_arg_1:String):void
        {
        }

        public function show():void
        {
            this.count = this.time;
            this._countDownTxt.text = (this.time - 1).toString();
            if (this.coutTimer)
            {
                this.coutTimer.stop();
                this.coutTimer.removeEventListener(TimerEvent.TIMER, this.__onTimeComplete);
            };
            if (this.coutTimer_1)
            {
                this.coutTimer_1.stop();
                this.coutTimer_1.removeEventListener(TimerEvent.TIMER, this.__onTimeComplete);
            };
            this.coutTimer = new Timer((this.time * 1000), 1);
            this.coutTimer_1 = new Timer(1000, this.time);
            if (StateManager.isInFight)
            {
                this._showTimer.addEventListener(TimerEvent.TIMER, this.__show);
                this._showTimer.start();
            }
            else
            {
                this.popup();
            };
        }

        private function __show(_arg_1:TimerEvent):void
        {
            if ((!(StateManager.isInFight)))
            {
                this._showTimer.removeEventListener(TimerEvent.TIMER, this.__show);
                this._showTimer.stop();
                this.popup();
            };
        }

        private function popup():void
        {
            SoundManager.instance.play("057");
            this.isShowed = true;
            this.x = (220 + ((Math.random() * 150) - 75));
            this.y = (110 + ((Math.random() * 200) - 100));
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, false, LayerManager.BLCAK_BLOCKGOUND);
            this._input = "";
            this.restartTimer();
        }

        public function close():void
        {
            if (this.coutTimer)
            {
                this.coutTimer.stop();
                this.coutTimer.removeEventListener(TimerEvent.TIMER, this.__onTimeComplete);
            };
            if (this.coutTimer_1)
            {
                this.coutTimer_1.stop();
                this.coutTimer_1.removeEventListener(TimerEvent.TIMER, this.__onTimeComplete);
            };
            if (parent)
            {
                parent.removeChild(this);
            };
            this.checkCount = 0;
            this._input = "";
            addEventListener(KeyboardEvent.KEY_DOWN, this.__resposeHandler);
            removeEventListener(Event.ENTER_FRAME, this.inFrameStart);
            dispatchEvent(new Event(Event.CLOSE));
            this.textChange();
        }

        override protected function __onAddToStage(_arg_1:Event):void
        {
            addEventListener(KeyboardEvent.KEY_DOWN, this.__resposeHandler);
        }

        private function __okBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((getTimer() - this._cheatTime) <= 500)
            {
                this._input = "";
                SocketManager.Instance.out.sendCheckCode("cheat");
                return;
            };
            if (this.isValidText())
            {
                this.sendSelected();
            };
        }

        private function __clearBtnClick(_arg_1:MouseEvent):void
        {
            if (this.haveValidText())
            {
                SoundManager.instance.play("008");
                this._input = "";
                this.textChange();
            };
        }

        private function __resposeHandler(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.__okBtnClick(null);
            };
        }

        private function sendSelected():void
        {
            this.coutTimer.removeEventListener(TimerEvent.TIMER, this.__onTimeComplete);
            if ((!(FilterWordManager.IsNullorEmpty(this._input))))
            {
                SocketManager.Instance.out.sendCheckCode(this._input);
            }
            else
            {
                SocketManager.Instance.out.sendCheckCode("");
                this.restartTimer();
            };
            this._input = "";
            this.checkCount++;
            if (this.checkCount == 10)
            {
                this.checkCount = 0;
                this.coutTimer.removeEventListener(TimerEvent.TIMER, this.__onTimeComplete);
                this.close();
            };
        }

        private function restartTimer():void
        {
            this._cheatTime = 0;
            this.coutTimer.stop();
            this.coutTimer.reset();
            this.coutTimer.addEventListener(TimerEvent.TIMER, this.__onTimeComplete);
            this.coutTimer.start();
            this.coutTimer_1.stop();
            this.coutTimer_1.reset();
            this.coutTimer_1.addEventListener(TimerEvent.TIMER, this.__onTimeComplete_1);
            this.coutTimer_1.start();
            this._countDownTxt.text = (this.count - 1).toString();
            this.okBtn.enable = false;
            this.clearBtn.enable = false;
            removeEventListener(Event.ENTER_FRAME, this.inFrameStart);
            addEventListener(Event.ENTER_FRAME, this.inFrameStart);
            this.textChange();
        }

        public function get isShowed():Boolean
        {
            return (this._isShowed);
        }

        public function set isShowed(_arg_1:Boolean):void
        {
            this._isShowed = _arg_1;
        }


    }
}//package ddt.view

