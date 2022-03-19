// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.expedition.ExpeditionController

package SingleDungeon.expedition
{
    import flash.events.EventDispatcher;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.IEventDispatcher;
    import ddt.data.analyze.ExpeditionDataAnalyzer;
    import com.pickgliss.ui.ComponentFactory;
    import SingleDungeon.expedition.view.ExpeditionFrame;
    import SingleDungeon.expedition.view.HardModeExpeditionFrame;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import __AS3__.vec.Vector;
    import SingleDungeon.expedition.msg.FightMsgInfo;
    import road7th.comm.PackageIn;
    import SingleDungeon.hardMode.HardModeManager;
    import SingleDungeon.expedition.view.ExpeditionEvents;
    import ddt.manager.PlayerManager;
    import road7th.data.DictionaryData;
    import __AS3__.vec.*;

    public class ExpeditionController extends EventDispatcher 
    {

        private static var _instance:ExpeditionController;
        public static const PRE_SCENE:int = 201;

        private var _model:ExpeditionModel;
        private var _expeditionFrame:IExpeditionFrame;
        private var _loadXML:Boolean = false;
        private var _showStart:Boolean = false;
        private var _showStop:Boolean = false;
        private var _timerIsRunning:Boolean;

        public function ExpeditionController(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
            this._model = new ExpeditionModel();
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EXPEDITION, this.__socketReponse);
            this.initEvent();
        }

        public static function get instance():ExpeditionController
        {
            if ((!(_instance)))
            {
                _instance = new (ExpeditionController)();
            };
            return (_instance);
        }


        public function get model():ExpeditionModel
        {
            return (this._model);
        }

        public function get showStart():Boolean
        {
            return (this._showStart);
        }

        public function set showStart(_arg_1:Boolean):void
        {
            this._showStart = _arg_1;
        }

        public function get showStop():Boolean
        {
            return (this._showStop);
        }

        public function set showStop(_arg_1:Boolean):void
        {
            this._showStop = _arg_1;
        }

        public function setExpeditionInfoDic(_arg_1:ExpeditionDataAnalyzer):void
        {
            this._model.expeditionInfoDic = _arg_1.list;
        }

        public function show(_arg_1:uint):void
        {
            if (_arg_1 == ExpeditionModel.NORMAL_MODE)
            {
                this._expeditionFrame = (ComponentFactory.Instance.creatComponentByStylename("singledungeon.expeditionFrame") as ExpeditionFrame);
            }
            else
            {
                if (_arg_1 == ExpeditionModel.HARD_MODE)
                {
                    this._expeditionFrame = (ComponentFactory.Instance.creatComponentByStylename("singledungeon.hardModeExpeditionFrame") as HardModeExpeditionFrame);
                };
            };
            this._expeditionFrame.show();
        }

        public function hide():void
        {
            if (this._expeditionFrame)
            {
                ObjectUtils.disposeObject(this._expeditionFrame);
                this._expeditionFrame = null;
            };
        }

        public function sendSocket(_arg_1:int, _arg_2:Array=null):void
        {
            switch (_arg_1)
            {
                case 1:
                    SocketManager.Instance.out.sendExpeditionStart(1, _arg_2["sceneID"], 0, _arg_2["count"]);
                    return;
                case 2:
                    SocketManager.Instance.out.sendExpeditionAccelerate();
                    return;
                case 3:
                    SocketManager.Instance.out.sendExpeditionCancle();
                    return;
                case 4:
                    SocketManager.Instance.out.sendExpeditionUpdate();
                    return;
                case 5:
                    SocketManager.Instance.out.sendExpeditionStart(2, _arg_2[0], _arg_2[1]);
                    return;
            };
        }

        private function __expeditionSecondsHandle(_arg_1:TimeEvents):void
        {
            var _local_2:Number = TimeManager.Instance.Now().time;
            var _local_3:Number = (this._model.expeditionEndTime - _local_2);
            var _local_4:String = TimeManager.Instance.formatTimeToString1(_local_3);
            if (((_local_4.slice((_local_4.length - 2)) == "00") || (_local_3 <= 0)))
            {
                ExpeditionController.instance.sendSocket(4);
            };
            if (this._expeditionFrame)
            {
                if (_local_3 > 0)
                {
                    this._expeditionFrame.updateRemainTxt(_local_4);
                }
                else
                {
                    this._expeditionFrame.updateRemainTxt("00:00:00");
                };
            };
        }

        private function initEvent():void
        {
            TimeManager.addEventListener(TimeEvents.MINUTES, this.__updateFatigue);
        }

        private function __updateFatigue(_arg_1:TimeEvents):void
        {
            if (this._expeditionFrame)
            {
                this._expeditionFrame.updateFatigue();
            };
        }

        private function __socketReponse(_arg_1:ExpeditionEvents):void
        {
            var _local_12:Vector.<int>;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:Vector.<FightMsgInfo>;
            var _local_18:int;
            var _local_19:FightMsgInfo;
            var _local_2:String = _arg_1.action;
            var _local_3:PackageIn = _arg_1.pkg;
            var _local_4:int = _local_3.readByte();
            var _local_5:Vector.<int> = new Vector.<int>();
            _local_5.push(_local_3.readInt());
            _local_5.push(_local_3.readInt());
            var _local_6:Date = _local_3.readDate();
            var _local_7:int = _local_3.readInt();
            var _local_8:int = _local_3.readInt();
            var _local_9:ExpeditionInfo = new ExpeditionInfo();
            _local_9.ExpeditionType = _local_4;
            if (_local_4 == ExpeditionModel.NORMAL_MODE)
            {
                _local_9.SceneID = _local_5[0];
            }
            else
            {
                if (_local_4 == ExpeditionModel.HARD_MODE)
                {
                    _local_12 = new Vector.<int>();
                    _local_13 = 63;
                    while (_local_13 >= 0)
                    {
                        _local_14 = int((_local_13 / 32));
                        _local_15 = (1 << _local_13);
                        if ((_local_5[_local_14] & _local_15) != 0)
                        {
                            _local_12.push((_local_13 + PRE_SCENE));
                        };
                        _local_13--;
                    };
                    HardModeManager.instance.hardModeSceneList = _local_12;
                    _local_9.SceneID = _local_12[(_local_12.length - 1)];
                };
            };
            if (_local_2 != ExpeditionEvents.STOP)
            {
                _local_9.IsOnExpedition = ((_local_4 == 0) ? false : true);
            };
            _local_9.StartTime = _local_6;
            PlayerManager.Instance.Self.expeditionCurrent = _local_9;
            PlayerManager.Instance.Self.expeditionNumCur = _local_8;
            PlayerManager.Instance.Self.expeditionNumAll = _local_7;
            var _local_10:DictionaryData = new DictionaryData();
            var _local_11:int;
            while (_local_11 < (_local_8 - 1))
            {
                _local_16 = _local_3.readInt();
                _local_17 = new Vector.<FightMsgInfo>();
                _local_18 = 0;
                while (_local_18 < _local_16)
                {
                    _local_19 = new FightMsgInfo();
                    _local_19.templateID = _local_3.readInt();
                    _local_19.times = (_local_11 + 1);
                    _local_19.count = _local_3.readInt();
                    _local_17.push(_local_19);
                    _local_18++;
                };
                _local_10.add(_local_11, _local_17);
                _local_11++;
            };
            this._model.getItemsDic = _local_10;
            this.showStart = true;
            if (_local_2 != ExpeditionEvents.STOP)
            {
                if ((((_local_2 == ExpeditionEvents.START) || (_local_2 == ExpeditionEvents.UPDATE)) && (!(this._timerIsRunning))))
                {
                    this._timerIsRunning = true;
                    TimeManager.addEventListener(TimeEvents.SECONDS, this.__expeditionSecondsHandle);
                };
                if (_local_4 == ExpeditionModel.NORMAL_MODE)
                {
                    this._model.expeditionEndTime = (_local_9.StartTime.time + (((this._model.expeditionInfoDic[_local_9.SceneID].ExpeditionTime * 60) * 1000) * _local_7));
                }
                else
                {
                    if (_local_4 == ExpeditionModel.HARD_MODE)
                    {
                        this._model.expeditionEndTime = (_local_9.StartTime.time + HardModeManager.instance.getNeedTime());
                    };
                };
            }
            else
            {
                TimeManager.removeEventListener(TimeEvents.SECONDS, this.__expeditionSecondsHandle);
                this._timerIsRunning = false;
                this.showStop = true;
            };
            this._model.lastScenceID = _local_9.SceneID;
            dispatchEvent(new ExpeditionEvents(ExpeditionEvents.UPDATE, _local_2));
        }


    }
}//package SingleDungeon.expedition

