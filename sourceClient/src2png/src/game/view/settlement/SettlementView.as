// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.settlement.SettlementView

package game.view.settlement
{
    import flash.display.MovieClip;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.SimpleButton;
    import flash.geom.Rectangle;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.ComponentFactory;
    import game.GameManager;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import ddt.manager.GameInSocketOut;
    import flash.events.MouseEvent;
    import ddt.manager.StateManager;
    import ddt.manager.ChatManager;
    import com.pickgliss.ui.LayerManager;
    import room.model.RoomInfo;
    import ddt.manager.SocketManager;
    import ddt.states.StateType;
    import ddt.manager.PlayerManager;
    import flash.utils.setInterval;
    import ddt.data.goods.ItemTemplateInfo;
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.ItemManager;
    import flash.display.Sprite;
    import ddt.manager.MapManager;
    import ddt.data.map.DungeonInfo;
    import flash.utils.clearInterval;
    import com.pickgliss.utils.ObjectUtils;

    [Event(name="settleshowed", type="ddt.events.GameEvent")]
    public class SettlementView extends MovieClip implements Disposeable 
    {

        private const MAXNUM:int = 8;

        public var goldNum:MovieClip;
        public var expNum:MovieClip;
        public var VIPAdd:MovieClip;
        public var partyAdd:MovieClip;
        public var unionAdd:MovieClip;
        public var good1:MovieClip;
        public var good2:MovieClip;
        public var good3:MovieClip;
        public var good4:MovieClip;
        public var good5:MovieClip;
        public var good6:MovieClip;
        public var good7:MovieClip;
        public var good8:MovieClip;
        public var dt1:MovieClip;
        public var dt2:MovieClip;
        public var goodGrid:MovieClip;
        public var continueBtn:SimpleButton;
        public var quitBtn:SimpleButton;
        public var leftBtn:SimpleButton;
        public var rightBtn:SimpleButton;
        private var _list:Array;
        private var _rect:Rectangle;
        private var _expObj:Object;
        private var _differTimer:String;
        private var _diction:DictionaryData;
        private var remainTime:int = 6;
        private var intervalId:uint;
        private var _dropData:Array;
        private var totalPageNum:int;
        private var currentPageNum:int;
        private var _grade:int;
        private var currentGP:int;
        private var gpForVIP:int;
        private var gpForconsortia:int;

        public function SettlementView()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._diction = new DictionaryData();
            this._rect = ComponentFactory.Instance.creatCustomObject("settlement.cellRect");
            this._dropData = GameManager.Instance.dropData;
            this.totalPageNum = (this._dropData.length / this.MAXNUM);
            this._expObj = GameManager.Instance.Current.selfGamePlayer.expObj;
            this.currentGP = this._expObj.baseExp;
            this.gpForVIP = this._expObj.gpForVIP;
            this.gpForconsortia = this._expObj.consortiaSkill;
            SoundManager.instance.play("063");
        }

        private function initEvent():void
        {
            this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }

        private function onEnterFrame(_arg_1:Event):void
        {
            this.showData();
            this.rewardGoods();
            this.check();
        }

        private function __continueBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            GameInSocketOut.sendGameMissionStart(true);
            GameManager.Instance.addEventListener(GameManager.START_LOAD, this.__startLoading);
            GameManager.Instance.clearDropData();
        }

        protected function __startLoading(_arg_1:Event):void
        {
            this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            GameManager.Instance.removeEventListener(GameManager.START_LOAD, this.__startLoading);
            StateManager.getInGame_Step_6 = true;
            ChatManager.Instance.input.faceEnabled = false;
            if (GameManager.Instance.Current == null)
            {
                return;
            };
            LayerManager.Instance.clearnGameDynamic();
            GameManager.Instance.gotoRoomLoading();
            StateManager.getInGame_Step_7 = true;
        }

        private function __quitBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            if (GameManager.Instance.Current.roomType == RoomInfo.SINGLE_DUNGEON)
            {
                SocketManager.Instance.out.sendExitWalkScene();
                StateManager.setState(StateType.SINGLEDUNGEON);
            }
            else
            {
                if (((GameManager.Instance.Current.roomType == RoomInfo.CONSORTION_MONSTER) && (!(PlayerManager.Instance.Self.ConsortiaID == 0))))
                {
                    SocketManager.Instance.out.SendenterConsortion();
                }
                else
                {
                    StateManager.setState(StateType.MAIN);
                };
            };
            GameManager.Instance.clearDropData();
        }

        private function check():void
        {
            if (this.currentFrameLabel == "btn")
            {
                if (GameManager.Instance.Current.hasNextMission)
                {
                    this.quitBtn.visible = false;
                    this.continueBtn.visible = true;
                    this.continueBtn.addEventListener(MouseEvent.CLICK, this.__continueBtnClick);
                }
                else
                {
                    this.quitBtn.visible = true;
                    this.continueBtn.visible = false;
                    this.quitBtn.addEventListener(MouseEvent.CLICK, this.__quitBtnClick);
                };
                this.leftBtn.visible = false;
                if (this._dropData.length > this.MAXNUM)
                {
                    this.rightBtn.visible = true;
                }
                else
                {
                    this.rightBtn.visible = false;
                };
                if (this.dt1)
                {
                    this.dt1.gotoAndStop(this.remainTime);
                };
                this.intervalId = setInterval(this.downCount, 1000);
            };
            if (this.currentFrame == this.totalFrames)
            {
                stop();
                this.expNum.txt.text = this._expObj.gainGP;
                if (this.goodGrid)
                {
                    this.createNextPage(this.goodGrid, 0);
                    this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
                    this.leftBtn.addEventListener(MouseEvent.CLICK, this.leftRightBtnClick);
                    this.rightBtn.addEventListener(MouseEvent.CLICK, this.leftRightBtnClick);
                };
            };
        }

        private function createNextPage(_arg_1:MovieClip, _arg_2:int):void
        {
            var _local_4:int;
            var _local_5:ItemTemplateInfo;
            var _local_6:BaseCell;
            var _local_7:FilterFrameText;
            var _local_3:int = 1;
            while (_local_3 <= this.MAXNUM)
            {
                if (_arg_1[("good" + _local_3)])
                {
                    while (_arg_1[("good" + _local_3)].numChildren > 0)
                    {
                        _arg_1[("good" + _local_3)].removeChildAt(0);
                    };
                    if (_local_3 <= (this._dropData.length - (this.MAXNUM * _arg_2)))
                    {
                        _local_4 = ((_local_3 + (this.MAXNUM * _arg_2)) - 1);
                        _local_5 = ItemManager.Instance.getTemplateById(this._dropData[_local_4].itemId);
                        _local_6 = new BaseCell(new Sprite(), _local_5);
                        _local_6.setContentSize(this._rect.width, this._rect.height);
                        _arg_1[("good" + _local_3)].addChild(_local_6);
                        if (this._dropData[_local_4].count > 0)
                        {
                            _local_7 = ComponentFactory.Instance.creatComponentByStylename("settlement.goodsNum");
                            _local_7.text = this._dropData[_local_4].count.toString();
                            _arg_1[("good" + _local_3)].addChild(_local_7);
                        };
                    };
                };
                _local_3++;
            };
        }

        private function showData():void
        {
            if (((this.goldNum) && (!(this._diction.hasKey(this.goldNum)))))
            {
                this.goldNum.txt.text = GameManager.Instance.dropGlod.toString();
                this._diction.add(this.goldNum, true);
            };
            if (this.expNum)
            {
                if (this.currentGP <= this._expObj.gainGP)
                {
                    this.expNum.txt.text = this.currentGP;
                }
                else
                {
                    this.expNum.txt.text = this._expObj.gainGP;
                };
            };
            if (((this.VIPAdd) && (this.gpForVIP > 0)))
            {
                if ((!(this._diction.hasKey(this.VIPAdd))))
                {
                    this.VIPAdd.play();
                    this._diction.add(this.VIPAdd, true);
                };
                this.currentGP = (this.currentGP + Math.ceil((this.gpForVIP / 100)));
                this.gpForVIP = (this.gpForVIP - Math.ceil((this.gpForVIP / 100)));
            };
            if (((this.unionAdd) && (this.gpForconsortia > 0)))
            {
                if ((!(this._diction.hasKey(this.unionAdd))))
                {
                    this.unionAdd.play();
                    this._diction.add(this.unionAdd, true);
                };
                this.currentGP = (this.currentGP + Math.ceil((this.gpForconsortia / 100)));
                this.gpForconsortia = (this.gpForconsortia - Math.ceil((this.gpForconsortia / 100)));
            };
            if (((this.partyAdd) && (!(0 == 0))))
            {
                this.partyAdd.play();
            };
        }

        private function rewardGoods():void
        {
            var _local_2:ItemTemplateInfo;
            var _local_3:BaseCell;
            var _local_4:FilterFrameText;
            var _local_1:int = 1;
            while (((_local_1 <= this._dropData.length) && (_local_1 <= this.MAXNUM)))
            {
                if (((this[("good" + _local_1)]) && (this[("good" + _local_1)].numChildren == 1)))
                {
                    _local_2 = ItemManager.Instance.getTemplateById(this._dropData[(_local_1 - 1)].itemId);
                    _local_3 = new BaseCell(new Sprite(), _local_2);
                    _local_3.setContentSize(this._rect.width, this._rect.height);
                    _local_4 = ComponentFactory.Instance.creatComponentByStylename("settlement.goodsNum");
                    _local_4.text = this._dropData[(_local_1 - 1)].count.toString();
                    this[("good" + _local_1)].addChild(_local_3);
                    this[("good" + _local_1)].addChild(_local_4);
                };
                _local_1++;
            };
        }

        private function leftRightBtnClick(_arg_1:MouseEvent):void
        {
            if (_arg_1.target == this.leftBtn)
            {
                this.currentPageNum--;
                this.createNextPage(this.goodGrid, this.currentPageNum);
            }
            else
            {
                if (_arg_1.target == this.rightBtn)
                {
                    this.currentPageNum++;
                    this.createNextPage(this.goodGrid, this.currentPageNum);
                };
            };
            if (this.currentPageNum > 0)
            {
                this.leftBtn.visible = true;
            }
            else
            {
                this.leftBtn.visible = false;
            };
            if (this.currentPageNum < this.totalPageNum)
            {
                this.rightBtn.visible = true;
            }
            else
            {
                this.rightBtn.visible = false;
            };
        }

        public function updateList(_arg_1:int):void
        {
            var _local_2:DungeonInfo = MapManager.getDungeonInfo(_arg_1);
            if (_local_2)
            {
                this._list = _local_2.SimpleTemplateIds.split(",");
            };
        }

        private function downCount():void
        {
            this.remainTime--;
            SoundManager.instance.play("048");
            if (((this.remainTime >= 0) && (this.remainTime < 100)))
            {
                if (this.dt1)
                {
                    this.dt1.gotoAndStop((int((this.remainTime % 10)) + 1));
                };
                if (this.dt2)
                {
                    this.dt2.gotoAndStop((int((this.remainTime / 10)) + 1));
                };
            };
            if (this.remainTime == 0)
            {
                clearInterval(this.intervalId);
                if (((GameManager.Instance.Current.hasNextMission) && (PlayerManager.Instance.Self.Fatigue >= PlayerManager.Instance.Self.NeedFatigue)))
                {
                    this.__continueBtnClick(null);
                }
                else
                {
                    this.__quitBtnClick(null);
                };
            };
        }

        private function removeEvent():void
        {
            if (((this.continueBtn) && (this.continueBtn.hasEventListener(MouseEvent.CLICK))))
            {
                this.continueBtn.removeEventListener(MouseEvent.CLICK, this.__continueBtnClick);
            };
            if (((this.quitBtn) && (this.quitBtn.hasEventListener(MouseEvent.CLICK))))
            {
                this.quitBtn.removeEventListener(MouseEvent.CLICK, this.__quitBtnClick);
            };
            if (((this.leftBtn) && (this.leftBtn.hasEventListener(MouseEvent.CLICK))))
            {
                this.leftBtn.removeEventListener(MouseEvent.CLICK, this.leftRightBtnClick);
                this.rightBtn.removeEventListener(MouseEvent.CLICK, this.leftRightBtnClick);
            };
            this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }

        public function dispose():void
        {
            this.removeEvent();
            clearInterval(this.intervalId);
            this._diction.clear();
            this._diction = null;
            this._list = null;
            this._expObj = null;
            this._rect = null;
            this._dropData = null;
            ObjectUtils.disposeObject(this.goodGrid);
            this.goodGrid = null;
            gotoAndStop(1);
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.settlement

