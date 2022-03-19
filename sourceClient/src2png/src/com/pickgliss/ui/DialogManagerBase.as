// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.DialogManagerBase

package com.pickgliss.ui
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.view.DialogView;
    import flash.display.Sprite;
    import flash.utils.Timer;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.getTimer;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.setTimeout;
    import flash.geom.Point;
    import flash.display.DisplayObject;
    import __AS3__.vec.*;

    public class DialogManagerBase extends EventDispatcher 
    {

        private static var _instance:DialogManagerBase;
        public static const HEAD_IMG_WIDTH:int = 150;
        public static const HEAD_IMG_HEIGHT:int = 220;
        public static const READY_TO_CLOSE:String = "readyToClose";

        private var _id:int;
        private var _currentDialogIndex:uint;
        private var _dialogViewArr:Vector.<DialogView>;
        private var _config:XML;
        private var _timeout:Number;
        private var _dialogBox:Sprite;
        private var _timeoutTimer:Timer;
        private var _parent:DisplayObjectContainer;
        private var _enableKeybord:Boolean;
        private var _enableMouse:Boolean;
        private var _topSprite:Sprite;
        private var _bottomSprite:Sprite;
        private var _mask:Sprite;
        private var _needCurtain:Boolean;
        private var _configUrl:String;
        private var _dialogAddedToStage:Boolean;
        private var _isShowing:Boolean;
        private var _curtainSpeed:int;

        public function DialogManagerBase()
        {
            this._dialogBox = new Sprite();
            this._dialogBox.addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public static function get Instance():DialogManagerBase
        {
            if (_instance == null)
            {
                _instance = new (DialogManagerBase)();
            };
            return (_instance);
        }


        public function setup(_arg_1:String):void
        {
            this._configUrl = _arg_1;
            var _local_2:URLLoader = new URLLoader();
            _local_2.addEventListener(Event.COMPLETE, this.__configComplete);
            _local_2.load(new URLRequest(((_arg_1 + "?lv=") + (getTimer() * Math.random()))));
        }

        private function createUI():void
        {
            this._mask = new Sprite();
            this._mask.graphics.beginFill(0, 0.5);
            this._mask.graphics.drawRect(0, 0, 1000, 600);
            this._mask.graphics.endFill();
            this._dialogBox.addChild(this._mask);
            this._topSprite = new Sprite();
            this._topSprite.graphics.beginFill(0);
            this._topSprite.graphics.drawRect(0, -120, 1000, 120);
            this._topSprite.graphics.endFill();
            this._dialogBox.addChild(this._topSprite);
            this._bottomSprite = new Sprite();
            this._bottomSprite.graphics.beginFill(0);
            this._bottomSprite.graphics.drawRect(0, 0, 1000, 120);
            this._bottomSprite.graphics.endFill();
            this._bottomSprite.y = 600;
            this._dialogBox.addChild(this._bottomSprite);
        }

        private function init(_arg_1:Event):void
        {
            this._parent = this._dialogBox.parent;
        }

        private function __switchDialog(_arg_1:MouseEvent=null):void
        {
            if (this._dialogViewArr == null)
            {
                return;
            };
            if ((!(this._dialogViewArr[this._currentDialogIndex])))
            {
                return;
            };
            if (this._dialogViewArr[this._currentDialogIndex].isRunning)
            {
                this._dialogViewArr[this._currentDialogIndex].showAllContentString();
                return;
            };
            this._dialogViewArr[this._currentDialogIndex].dispose();
            this._dialogViewArr[this._currentDialogIndex] = null;
            if (this._currentDialogIndex == (this._dialogViewArr.length - 1))
            {
                this._dialogViewArr = null;
                this._enableKeybord = false;
                this._dialogAddedToStage = false;
                if (this._timeoutTimer)
                {
                    this._timeoutTimer.stop();
                };
                if (this._enableMouse)
                {
                    this._dialogBox.removeEventListener(MouseEvent.CLICK, this.__switchDialog);
                };
                if (this._needCurtain)
                {
                    dispatchEvent(new Event(READY_TO_CLOSE));
                    this._dialogBox.addEventListener(Event.ENTER_FRAME, this.__curtainMoveDisappear);
                }
                else
                {
                    this.removeDialog();
                };
                return;
            };
            this._currentDialogIndex++;
            this._dialogBox.addChild(this._dialogViewArr[this._currentDialogIndex]);
            if (this._timeoutTimer)
            {
                this._timeoutTimer.reset();
                this._timeoutTimer.start();
            };
        }

        private function __configComplete(_arg_1:Event=null):void
        {
            var _local_2:URLLoader = (_arg_1.currentTarget as URLLoader);
            _local_2.removeEventListener(Event.COMPLETE, this.__configComplete);
            this._config = new XML(_local_2.data);
        }

        private function createDialogUI():void
        {
            var resultXML:XMLList;
            var chat:XML;
            var dialogView:DialogView;
            var showMouse:Boolean;
            var content:String;
            resultXML = this._config.team.(@id == _id);
            if (resultXML.@id == undefined)
            {
                return;
            };
            this._currentDialogIndex = 0;
            this._dialogViewArr = new Vector.<DialogView>();
            for each (chat in resultXML..item)
            {
                dialogView = new DialogView();
                if (resultXML..role.(@id == chat.@roleid).@name == "self")
                {
                    dialogView.setName(this.SelfName());
                    dialogView.setHeadImgIndex(chat.@faceid);
                }
                else
                {
                    dialogView.setName(resultXML..role.(@id == chat.@roleid).@name);
                    dialogView.setHeadImgIndex(chat.@faceid);
                };
                showMouse = true;
                if (((!(this._enableKeybord)) && (!(this._enableMouse))))
                {
                    showMouse = false;
                };
                content = chat.@content;
                dialogView.setContent(content.replace(/t\%/g, this.SelfName()), showMouse, this._config.@time);
                this._dialogViewArr.push(dialogView);
                dialogView.x = 15;
                dialogView.y = 416;
            };
            this._mask.alpha = 0;
            this._topSprite.y = 0;
            this._bottomSprite.y = 600;
            if (this._needCurtain)
            {
                this.showCurtain();
            }
            else
            {
                this.addDialog();
            };
        }

        private function __dialogTimeout(_arg_1:TimerEvent):void
        {
            this.__switchDialog();
        }

        public function showDialog(id:int, timeout:Number=0, enableKeybord:Boolean=true, enableMouse:Boolean=true, needCurtain:Boolean=true, curtainSpeed:int=4):void
        {
            var resultXML:XMLList;
            if ((!(this._parent)))
            {
                throw (new Error("先添加对话框到舞台再调用showDialog方法！"));
            };
            if (id < 0)
            {
                return;
            };
            if ((!(this.hasDialogs(id))))
            {
                dispatchEvent(new Event(READY_TO_CLOSE));
                dispatchEvent(new Event(Event.COMPLETE));
                return;
            };
            this.createUI();
            this._id = id;
            this._enableKeybord = enableKeybord;
            this._enableMouse = enableMouse;
            this._needCurtain = needCurtain;
            this._curtainSpeed = curtainSpeed;
            this._isShowing = true;
            if (timeout > 0)
            {
                this._timeoutTimer = new Timer(timeout, 0);
                this._timeoutTimer.addEventListener(TimerEvent.TIMER, this.__dialogTimeout);
            };
            if (this._config)
            {
                resultXML = this._config.team.(@id == id);
                this.createDialogUI();
            }
            else
            {
                setTimeout(this.showDialog, 500, id, timeout, enableKeybord, enableMouse, needCurtain);
            };
        }

        public function dropGoodsId(id:int):int
        {
            var resultXML:XMLList;
            if (this._config)
            {
                resultXML = this._config.team.(@id == id);
                if ((!(resultXML)))
                {
                    return (-1);
                };
                if (resultXML.length() == 0)
                {
                    return (-1);
                };
                if (resultXML[0].@goodsId != undefined)
                {
                    return (resultXML[0].@goodsId);
                };
                return (-1);
            };
            return (-1);
        }

        public function dropGoodsBeforeDialog(id:int):Boolean
        {
            var resultXML:XMLList;
            if (this._config)
            {
                resultXML = this._config.team.(@id == id);
                if ((!(resultXML)))
                {
                    return (false);
                };
                if (resultXML.length() == 0)
                {
                    return (false);
                };
                if (resultXML[0].@dropBeforeDialog != undefined)
                {
                    return (Boolean(int(resultXML[0].@dropBeforeDialog)));
                };
                return (false);
            };
            return (false);
        }

        public function hasDialogs(id:int):Boolean
        {
            var resultXML:XMLList;
            var count:uint;
            var chat:XML;
            if (this._config)
            {
                resultXML = this._config.team.(@id == id);
                if ((!(resultXML)))
                {
                    return (false);
                };
                if (resultXML.length() == 0)
                {
                    return (false);
                };
                count = 0;
                for each (chat in resultXML..item)
                {
                    count++;
                };
                if (count == 0)
                {
                    return (false);
                };
                return (true);
            };
            return (false);
        }

        public function getDropPoint(id:int):Point
        {
            var resultXML:XMLList;
            var p:Point = new Point(-1, -1);
            if (this._config)
            {
                resultXML = this._config.team.(@id == id);
                if ((!(resultXML)))
                {
                    return (null);
                };
                if (resultXML.length() == 0)
                {
                    return (null);
                };
                if (((!(resultXML[0].@dropX == undefined)) && (!(resultXML[0].@dropY == undefined))))
                {
                    p.x = int(resultXML[0].@dropX);
                    p.y = int(resultXML[0].@dropY);
                    return (p);
                };
                return (null);
            };
            return (null);
        }

        public function get DialogBox():Sprite
        {
            return (this._dialogBox);
        }

        public function get showing():Boolean
        {
            return (this._isShowing);
        }

        public function KeyDown():void
        {
            if ((!(this._dialogAddedToStage)))
            {
                return;
            };
            if (this._enableKeybord)
            {
                this.__switchDialog();
            };
        }

        private function showCurtain():void
        {
            this._dialogBox.addEventListener(Event.ENTER_FRAME, this.__curtainMoveAppear);
        }

        private function __curtainMoveAppear(_arg_1:Event):void
        {
            this._topSprite.y = (this._topSprite.y + this._curtainSpeed);
            this._bottomSprite.y = (this._bottomSprite.y - this._curtainSpeed);
            this._mask.alpha = (this._mask.alpha + 0.04);
            if (this._topSprite.y >= 100)
            {
                this._dialogBox.removeEventListener(Event.ENTER_FRAME, this.__curtainMoveAppear);
                this.addDialog();
            };
        }

        private function __curtainMoveDisappear(_arg_1:Event):void
        {
            this._topSprite.y = (this._topSprite.y - this._curtainSpeed);
            this._bottomSprite.y = (this._bottomSprite.y + this._curtainSpeed);
            this._mask.alpha = (this._mask.alpha - 0.04);
            if (this._topSprite.y <= 0)
            {
                this._dialogBox.removeEventListener(Event.ENTER_FRAME, this.__curtainMoveDisappear);
                this.removeDialog();
            };
        }

        private function addDialog():void
        {
            this._dialogBox.addChild(this._dialogViewArr[this._currentDialogIndex]);
            this._dialogViewArr[this._currentDialogIndex].headMc.play();
            this._dialogAddedToStage = true;
            if (this._timeoutTimer)
            {
                this._timeoutTimer.start();
            };
            if (this._enableMouse)
            {
                this._dialogBox.addEventListener(MouseEvent.CLICK, this.__switchDialog);
            };
        }

        private function removeDialog():void
        {
            if (this._dialogBox.hasEventListener(Event.ENTER_FRAME))
            {
                this._dialogBox.removeEventListener(Event.ENTER_FRAME, this.__curtainMoveDisappear);
            };
            this._currentDialogIndex = 0;
            if (this._timeoutTimer)
            {
                this._timeoutTimer.stop();
                this._timeoutTimer.removeEventListener(TimerEvent.TIMER, this.__dialogTimeout);
                this._timeoutTimer = null;
            };
            while (this._dialogBox.numChildren > 0)
            {
                this._dialogBox.removeChildAt(0);
            };
            if (this._parent)
            {
                this._parent.removeChild(this._dialogBox);
            };
            this._parent = null;
            this._isShowing = false;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        protected function Self(_arg_1:int):DisplayObject
        {
            return (new Sprite());
        }

        protected function SelfName():String
        {
            return ("弹弹勇士");
        }


    }
}//package com.pickgliss.ui

