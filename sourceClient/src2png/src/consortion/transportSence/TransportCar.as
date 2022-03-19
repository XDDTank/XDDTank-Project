// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.transportSence.TransportCar

package consortion.transportSence
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import com.pickgliss.ui.text.FilterFrameText;
    import consortion.TransportCarInfoTip;
    import flash.display.Shape;
    import flash.utils.Timer;
    import flash.filters.GlowFilter;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import ddt.manager.TimeManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.loader.ModuleLoader;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.TimerEvent;
    import consortion.ConsortionModelControl;
    import ddt.events.TimeEvents;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.data.BuffInfo;
    import ddt.data.player.ConsortiaPlayerInfo;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class TransportCar extends Sprite implements Disposeable 
    {

        public static const CARI:uint = 1;
        public static const CARII:uint = 2;
        public static const CAR_FINISH_USE_TIME:int = 900000;
        public static const MOVE_DISTANCE:int = 2500;

        private var _type:uint;
        private var _info:TransportCarInfo;
        private var _carMc:MovieClip;
        private var _carName:FilterFrameText;
        private var _tip:TransportCarInfoTip;
        private var _nameBg:Shape;
        private var _carRunTimer:Timer;
        private var _speed:Number;
        private var _nickName:String;
        private var _fightIcon:MovieClip;
        private var _myCite:MovieClip;
        private var _currentClassName:String;
        private var _loadLivingTimer:Timer;
        private var _canHijack:Boolean;

        public function TransportCar(_arg_1:uint)
        {
            this._type = _arg_1;
            this._info = new TransportCarInfo(this._type);
            this._info.speed = this._speed;
        }

        public function createCarByType():void
        {
            var _local_1:GlowFilter;
            this._fightIcon = ComponentFactory.Instance.creat("asset.transportCar.fighting");
            this._fightIcon.visible = false;
            this._myCite = ComponentFactory.Instance.creatCustomObject("consortiontransport.myselfCite");
            if (PlayerManager.Instance.Self.consortiaInfo.ConsortiaName == this._info.consortionName)
            {
                this._carName = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.transport.carNameGreenText");
            }
            else
            {
                if (Math.abs((this._info.ownerLevel - PlayerManager.Instance.Self.Grade)) > 5)
                {
                    this._carName = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.transport.carNameWhiteText");
                }
                else
                {
                    this._carName = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.transport.carNameRedText");
                    this._canHijack = true;
                };
            };
            this._info.movePercent = ((((TimeManager.Instance.Now().valueOf() - this._info.startDate.valueOf()) / 1000) * this._speed) / MOVE_DISTANCE);
            switch (this._type)
            {
                case CARI:
                    this._currentClassName = "game.living.Living239";
                    this._nickName = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.normalCarName.text");
                    break;
                case CARII:
                    this._currentClassName = "game.living.Living240";
                    this._nickName = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.highClassCarName.text");
                    this._fightIcon.x = 25;
                    this._fightIcon.y = -144;
                    this._carName.x = 59;
                    this._carName.y = -113;
                    this._myCite.x = 25;
                    this._myCite.y = -133;
                    break;
            };
            if (ModuleLoader.hasDefinition(this._currentClassName))
            {
                this._carMc = ClassUtils.CreatInstance(this._currentClassName);
            }
            else
            {
                this._carMc = (ClassUtils.CreatInstance("asset.game.defaultImage") as MovieClip);
                this._loadLivingTimer = new Timer(500);
                this._loadLivingTimer.addEventListener(TimerEvent.TIMER, this.__checkActionIsReady);
                this._loadLivingTimer.start();
            };
            if (((this._info.ownerId == PlayerManager.Instance.Self.ID) || (this._info.guarderId == PlayerManager.Instance.Self.ID)))
            {
                if (ModuleLoader.hasDefinition(this._currentClassName))
                {
                    _local_1 = new GlowFilter(16777164, 1, 10, 10, 2.2);
                    this._carMc.filters = [_local_1];
                    addChild(this._myCite);
                };
                this.buttonMode = false;
                this.useHandCursor = false;
            }
            else
            {
                this.buttonMode = true;
                this.useHandCursor = true;
            };
            this._info.nickName = this._nickName;
            this._carName.text = (((("[" + this._info.ownerName) + "]") + LanguageMgr.GetTranslation("consortion.ConsortionTransport.carName3")) + this._info.nickName);
            this._nameBg = new Shape();
            this._nameBg.graphics.beginFill(0, 0.5);
            this._nameBg.graphics.drawRoundRect(-4, 0, (this._carName.textWidth + 8), 22, 5, 5);
            this._nameBg.graphics.endFill();
            this._nameBg.x = (this._carName.x + 3);
            this._nameBg.y = (this._carName.y - 3);
            addChild(this._carMc);
            addChild(this._nameBg);
            addChild(this._carName);
            addChild(this._fightIcon);
            if ((!(ModuleLoader.hasDefinition(this._currentClassName))))
            {
                this._nameBg.visible = false;
                this._carName.visible = false;
            };
            this._tip = new TransportCarInfoTip();
            this._tip.visible = false;
            this._tip.tipData = ConsortionModelControl.Instance.model.getCarInfoTip(this._info);
            this.createFightMc();
            this.addEvent();
        }

        private function addEvent():void
        {
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__carMove);
            this.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
            this.addEventListener(MouseEvent.CLICK, this.__sendHijack);
        }

        private function removeEvent():void
        {
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__carMove);
            this.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            this.removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
            this.removeEventListener(MouseEvent.CLICK, this.__sendHijack);
        }

        protected function __checkActionIsReady(_arg_1:TimerEvent):void
        {
            var _local_2:GlowFilter;
            if (ModuleLoader.hasDefinition(this._currentClassName))
            {
                this._loadLivingTimer.stop();
                this._loadLivingTimer.removeEventListener(TimerEvent.TIMER, this.__checkActionIsReady);
                this._loadLivingTimer = null;
                removeChild(this._carMc);
                this._carMc = null;
                this._carMc = ClassUtils.CreatInstance(this._currentClassName);
                addChild(this._carMc);
                this._nameBg.visible = true;
                this._carName.visible = true;
                if (((this._info.ownerId == PlayerManager.Instance.Self.ID) || (this._info.guarderId == PlayerManager.Instance.Self.ID)))
                {
                    _local_2 = new GlowFilter(16777164, 1, 10, 10, 2.2);
                    this._carMc.filters = [_local_2];
                    addChild(this._myCite);
                };
            };
        }

        private function createFightMc():void
        {
            if ((!(this._fightIcon)))
            {
                return;
            };
            if (((this._info.truckState == TransportCarInfo.ISHIJACKING) || ((TimeManager.Instance.Now().valueOf() - this._info.lastHijackDate.valueOf()) < 30000)))
            {
                this._fightIcon.visible = true;
            }
            else
            {
                this._fightIcon.visible = false;
            };
        }

        private function __carComplete(_arg_1:TimerEvent):void
        {
            if (this._carRunTimer)
            {
                this._carRunTimer.stop();
                this._carRunTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__carComplete);
                this._carRunTimer = null;
                this.sendCarComplete();
            };
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if (this._tip)
            {
                this._tip.visible = true;
                this._tip.updateTime();
                LayerManager.Instance.addToLayer(this._tip, LayerManager.GAME_TOP_LAYER);
                _local_2 = this.localToGlobal(new Point(64, -30));
                if ((_local_2.x + this._tip.width) > 1000)
                {
                    _local_2.x = (1000 - this._tip.width);
                };
                if ((_local_2.y + this._tip.height) > 600)
                {
                    _local_2.y = (600 - this._tip.height);
                };
                this._tip.x = _local_2.x;
                this._tip.y = _local_2.y;
            };
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            if (this._tip)
            {
                this._tip.visible = false;
            };
        }

        private function __sendHijack(_arg_1:MouseEvent):void
        {
            var _local_5:uint;
            if (PlayerManager.Instance.Self.ConsortiaID == 0)
            {
                TransportManager.Instance.currentCar = null;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionTransport.noConsortionError.txt", 15));
                return;
            };
            if ((TimeManager.Instance.Now().valueOf() - this._info.lastHijackDate.valueOf()) < 30000)
            {
                TransportManager.Instance.currentCar = null;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionTransport.thisCarIsHijackingError.txt", 15));
                return;
            };
            if (Math.abs((this._info.ownerLevel - PlayerManager.Instance.Self.Grade)) > 5)
            {
                TransportManager.Instance.currentCar = null;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionTransport.hijackHighLevelError.txt", 15));
                return;
            };
            if (this._info.truckState == TransportCarInfo.ISHIJACKING)
            {
                TransportManager.Instance.currentCar = null;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionTransport.thisCarIsHijackingError.txt", 15));
                return;
            };
            if (this._info.hijackerIdList.length > 0)
            {
                _local_5 = 0;
                while (_local_5 < this._info.hijackerIdList.length)
                {
                    if (PlayerManager.Instance.Self.ID == this._info.hijackerIdList[_local_5])
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionTransport.hijackSameCarError.txt", 15));
                        return;
                    };
                    _local_5++;
                };
            };
            var _local_2:BuffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.ADD_HIJACK_COUNT];
            var _local_3:int;
            if (_local_2)
            {
                _local_3 = _local_2.Value;
            };
            var _local_4:ConsortiaPlayerInfo = ConsortionModelControl.Instance.model.getConsortiaMemberInfo(this._info.ownerId);
            if (_local_4)
            {
                if (this._info.ownerId == PlayerManager.Instance.Self.ID)
                {
                    TransportManager.Instance.currentCar = null;
                    return;
                };
                TransportManager.Instance.currentCar = null;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.sameConsortionError.text", 15));
                return;
            };
            _local_4 = ConsortionModelControl.Instance.model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID);
            if (_local_4.HijackTimes >= (_local_4.MaxHijackTimes + _local_3))
            {
                TransportManager.Instance.currentCar = null;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionTransport.myHijackTimeEndError.txt", 15));
                return;
            };
            if (this._info.hijackTimes >= TransportCarInfo.MAX_HIJACKED_TIMES)
            {
                TransportManager.Instance.currentCar = null;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.maxHijackError.text", 15));
                return;
            };
            if (ConsortionModelControl.Instance.model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID).GuardTruckId != 0)
            {
                TransportManager.Instance.currentCar = null;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionTransport.isConvoyingError.txt", 15));
                return;
            };
            if (TransportManager.Instance.transportModel.hasMyCar())
            {
                TransportManager.Instance.currentCar = null;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionTransport.isConvoyingError.txt", 15));
                return;
            };
            if ((!(PlayerManager.Instance.Self.Bag.getItemAt(14))))
            {
                TransportManager.Instance.currentCar = null;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionTransport.fightError.txt", 15));
                return;
            };
            if (this._info.ownerId != PlayerManager.Instance.Self.ID)
            {
                TransportManager.Instance.currentCar = this;
            }
            else
            {
                TransportManager.Instance.currentCar = null;
            };
        }

        private function __carMove(_arg_1:TimeEvents):void
        {
            this.x = (this.x + this._speed);
            this.createFightMc();
            if ((this.x - 85) >= MOVE_DISTANCE)
            {
                TimeManager.removeEventListener(TimeEvents.SECONDS, this.__carMove);
                if (this._carRunTimer)
                {
                    if (this._carRunTimer.running)
                    {
                        this._carRunTimer.stop();
                        this._carRunTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__carComplete);
                        this._carRunTimer = null;
                    };
                };
                this.sendCarComplete();
            };
        }

        private function sendCarComplete():void
        {
            SocketManager.Instance.out.SendCarReceive();
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._carMc);
            this._carMc = null;
            ObjectUtils.disposeObject(this._carName);
            this._carName = null;
            ObjectUtils.disposeObject(this._nameBg);
            this._nameBg = null;
            ObjectUtils.disposeObject(this._info);
            this._info = null;
            ObjectUtils.disposeObject(this._tip);
            this._tip = null;
            ObjectUtils.disposeObject(this._myCite);
            this._myCite = null;
            ObjectUtils.disposeObject(this._fightIcon);
            this._fightIcon = null;
            ObjectUtils.disposeObject(this._loadLivingTimer);
            this._loadLivingTimer = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function get info():TransportCarInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:TransportCarInfo):void
        {
            var _local_2:int;
            this._info = _arg_1;
            this._info.movePercent = ((((TimeManager.Instance.Now().valueOf() - this._info.startDate.valueOf()) / 1000) * this._speed) / MOVE_DISTANCE);
            this.createFightMc();
            if (this._tip)
            {
                this._tip.tipData = ConsortionModelControl.Instance.model.getCarInfoTip(this._info);
            };
            if (this._info.ownerId == PlayerManager.Instance.Self.ID)
            {
                this.buttonMode = false;
                this.useHandCursor = false;
                if (this._carRunTimer)
                {
                    this._carRunTimer.stop();
                };
                _local_2 = int(int(((MOVE_DISTANCE - (((TimeManager.Instance.Now().valueOf() - this._info.startDate.valueOf()) / 1000) * this._speed)) / this._speed)));
                if (_local_2 > 0)
                {
                    if (_local_2 < 1)
                    {
                        this._carRunTimer = new Timer((_local_2 * 1000), 1);
                    }
                    else
                    {
                        this._carRunTimer = new Timer(1000, _local_2);
                    };
                    this._carRunTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__carComplete);
                    this._carRunTimer.start();
                };
            };
        }

        public function get speed():Number
        {
            return (this._speed);
        }

        public function set speed(_arg_1:Number):void
        {
            this._speed = _arg_1;
        }

        public function get nickName():String
        {
            return (this._nickName);
        }

        public function set nickName(_arg_1:String):void
        {
            this._nickName = _arg_1;
        }

        public function get canHijack():Boolean
        {
            return (this._canHijack);
        }


    }
}//package consortion.transportSence

