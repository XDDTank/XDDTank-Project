// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.GameView

package game.view
{
    import flash.utils.Dictionary;
    import flash.display.Sprite;
    import game.view.experience.ExpView;
    import com.greensock.TweenLite;
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import road7th.utils.MovieClipWrapper;
    import game.view.settlement.SettlementViewFightRobot;
    import game.model.MissionAgainInfo;
    import game.view.settlement.SettlementView;
    import game.view.settlement.SettlementViewPVP;
    import org.aswing.KeyboardManager;
    import road7th.data.DictionaryEvent;
    import ddt.events.GameEvent;
    import ddt.manager.PlayerManager;
    import ddt.events.BagEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.StatisticManager;
    import flash.events.TimerEvent;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import ddt.view.BackgoundView;
    import game.GameManager;
    import room.RoomManager;
    import room.model.RoomInfo;
    import ddt.manager.ChatManager;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import ddt.states.BaseStateView;
    import ddt.manager.DialogManager;
    import road7th.comm.PackageIn;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import flash.utils.setTimeout;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.Event;
    import game.model.Living;
    import road7th.data.DictionaryData;
    import game.model.Player;
    import ddt.manager.MessageTipManager;
    import game.objects.GameSysMsgType;
    import flash.display.DisplayObject;
    import com.pickgliss.toplevel.StageReferance;
    import flash.display.DisplayObjectContainer;
    import ddt.states.StateType;
    import game.objects.SimpleObject;
    import ddt.manager.PageInterfaceManager;
    import flash.utils.clearTimeout;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.StateManager;
    import ddt.manager.BallManager;
    import ddt.loader.StartupResourceLoader;
    import game.objects.GameLiving;
    import game.model.GameModeType;
    import game.model.TurnedLiving;
    import ddt.manager.SavePointManager;
    import game.actions.ChangePlayerAction;
    import game.actions.ChangeNpcAction;
    import game.objects.GamePlayer;
    import game.actions.PrepareShootAction;
    import game.model.SmallEnemy;
    import game.objects.GameSmallEnemy;
    import game.model.SimpleBoss;
    import game.objects.GameSimpleBoss;
    import com.pickgliss.loader.ModuleLoader;
    import game.objects.SimpleBox;
    import ddt.events.PhyobjEvent;
    import ddt.manager.SkillManager;
    import phy.object.PhysicalObj;
    import game.actions.ViewEachObjectAction;
    import game.objects.BossPlayer;
    import game.model.LocalPlayer;
    import flash.geom.Rectangle;
    import game.objects.BombAction;
    import game.objects.ActionType;
    import game.actions.ChangeBallAction;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.EquipType;
    import ddt.data.FightBuffInfo;
    import ddt.manager.BuffManager;
    import ddt.data.BuffType;
    import game.actions.PickBoxAction;
    import road7th.data.StringObject;
    import ddt.manager.PetSkillManager;
    import pet.date.PetSkillInfo;
    import ddt.events.LivingEvent;
    import game.actions.GameOverAction;
    import room.model.RoomPlayer;
    import game.actions.MissionOverAction;
    import game.TryAgain;
    import game.objects.LivingTypesEnum;
    import SingleDungeon.SingleDungeonManager;
    import game.model.GameInfo;
    import ddt.utils.MenoryUtil;
    import ddt.manager.MapManager;
    import ddt.data.map.DungeonInfo;
    import arena.ArenaManager;
    import com.greensock.easing.Sine;
    import ddt.manager.GameInSocketOut;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.PropInfo;
    import road7th.utils.AutoDisappear;
    import ddt.view.PropItemView;
    import game.model.GameNeedMovieInfo;
    import bagAndInfo.cell.BaseCell;
    import game.animations.ShockMapAnimation;
    import game.animations.PhysicalObjFocusAnimation;
    import game.view.effects.ShootPercentView;

    public class GameView extends GameViewBase 
    {

        private const ZXC_OFFSET:int = 24;

        protected var _msg:String = "";
        protected var _tipItems:Dictionary;
        protected var _tipLayers:Sprite;
        protected var _result:ExpView;
        protected var _hitsNumView:HitsNumView;
        private var _dropGoodsTween:TweenLite;
        private var _timeoutMark1:uint;
        private var _timeoutMark2:uint;
        private var _goodsMovie1:MovieClip;
        private var _goodsMovie2:MovieClip;
        private var _syncTimer:Timer;
        private var _iconWrapper1:MovieClipWrapper;
        private var _iconWrapper2:MovieClipWrapper;
        private var _settlementFightRobot:SettlementViewFightRobot;
        private var _gameOverTimer:Timer = new Timer(100);
        private var numCh:Number;
        private var _soundPlayFlag:Boolean;
        private var _ignoreSmallEnemy:Boolean;
        private var _turnMovie:MovieClipWrapper;
        private var _boxArr:Array;
        private var _missionAgain:MissionAgainInfo;
        protected var _expView:ExpView;
        private var _settlement:SettlementView;
        private var _settlementPVP:SettlementViewPVP;
        private var _timer:Timer;
        private var _enermy:Array;
        private var _enermyNum:int;


        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1, _arg_2);
            KeyboardManager.getInstance().isStopDispatching = false;
            _gameInfo.resetResultCard();
            _gameInfo.livings.addEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            _gameInfo.addEventListener(GameEvent.WIND_CHANGED, this.__windChanged);
            PlayerManager.Instance.Self.FightBag.addEventListener(BagEvent.UPDATE, this.__selfObtainItem);
            PlayerManager.Instance.Self.TempBag.addEventListener(BagEvent.UPDATE, this.__getTempItem);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE, this.__missionOver);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_OVER, this.__gameOver);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT, this.__shoot);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE, this.__startMove);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE, this.__playerChange);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_BLOOD, this.__playerBlood);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_VANE, this.__changWind);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_HIDE, this.__playerHide);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_NONOLE, this.__playerNoNole);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_PROP, this.__playerUsingItem);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_DANDER, this.__dander);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REDUCE_DANDER, this.__reduceDander);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK, this.__changeShootCount);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SUICIDE, this.__suicide);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG, this.__beginShoot);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_BALL, this.__changeBall);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_FROST, this.__forstPlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_MOVIE, this.__playMovie);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_CHAGEANGLE, this.__livingTurnRotation);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_SOUND, this.__playSound);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_LIVING, this.__addLiving);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_MOVETO, this.__livingMoveto);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_FALLING, this.__livingFalling);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_JUMP, this.__livingJump);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BEAT, this.__livingBeat);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SAY, this.__livingSay);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING, this.__livingRangeAttacking);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED, this.__livingDirChanged);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT, this.__focusOnObject);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_STATE, this.__changeState);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BARRIER_INFO, this.__barrierInfoHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_MAP_THINGS, this.__addMapThing);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BOARD_STATE, this.__updatePhysicObject);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR, this.__removePhysicObject);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER, this.__addTipLayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FORBID_DRAG, this.__forbidDragFocus);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOP_LAYER, this.__topLayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTROL_BGM, this.__controlBGM);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE, this.__onLivingBoltmove);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_TARGET, this.__onChangePlayerTarget);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SHOW_BLOOD, this.__livingShowBlood);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SHOW_NPC, this.__livingShowNpc);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTION_MAPPING, this.__livingActionMapping);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BUFF, this.__updateBuff);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_BUFF, this.__updatePetBuff);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAMESYSMESSAGE, this.__gameSysMessage);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_PROPERTY, this.__objectSetProperty);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_PET_SKILL, this.__usePetSkill);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_BOX_SKILL, this.__useFightKitSkillSocket);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DROP_GOODS, this.__onDropItemComplete);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_DIALOG, this.__getDialogFromServer);
            _selfMarkBar.addEventListener(GameEvent.SINGLE_TURN_NOTICE, this.__changePlayerInsingle);
            StatisticManager.Instance().startAction(StatisticManager.GAME, "yes");
            this._syncTimer = new Timer(10000);
            this._syncTimer.addEventListener(TimerEvent.TIMER, this.__syncLifeTime);
            this._syncTimer.start();
            this._tipItems = new Dictionary(true);
            CacheSysManager.lock(CacheConsts.ALERT_IN_FIGHT);
            PlayerManager.Instance.Self.isUpGradeInGame = false;
            BackgoundView.Instance.hide();
            this._hitsNumView = new HitsNumView();
            addChild(this._hitsNumView);
            GameManager.Instance.hitsNumView = this._hitsNumView;
            if (RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
            {
                ChatManager.Instance.input.faceEnabled = false;
            };
            GameManager.Instance.addEventListener(GameEvent.LOCK_SCREEN, this.__lockScreenHandler);
            this._gameOverTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__doGameOver);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
            addEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDown);
        }

        private function __syncLifeTime(_arg_1:TimerEvent):void
        {
            SocketManager.Instance.out.syncLifeTime();
        }

        private function __getDialogFromServer(_arg_1:CrazyTankSocketEvent):void
        {
            if (DialogManager.Instance.showing)
            {
                return;
            };
            var _local_2:PackageIn = _arg_1.pkg;
            GameManager.Instance.dialogId = _local_2.readInt();
            GameManager.Instance.dropTaskGoodsNpcId = _local_2.readInt();
            GameManager.Instance.dropTaskGoodsId = DialogManager.Instance.dropGoodsId(GameManager.Instance.dialogId);
            if ((!(DialogManager.Instance.hasDialogs(GameManager.Instance.dialogId))))
            {
                GameManager.Instance.dialogId = -1;
            };
            if (GameManager.Instance.dropTaskGoodsId == -1)
            {
                this.showDialog(GameManager.Instance.dialogId);
            }
            else
            {
                if (DialogManager.Instance.getDropPoint(GameManager.Instance.dialogId))
                {
                    if (DialogManager.Instance.dropGoodsBeforeDialog(GameManager.Instance.dialogId))
                    {
                        this.dropGoods();
                    }
                    else
                    {
                        this.showDialog(GameManager.Instance.dialogId);
                    };
                };
            };
        }

        private function dropGoods():void
        {
            var _local_2:String;
            var _local_4:Point;
            this.setMapFocusLock(true);
            var _local_1:Point = DialogManager.Instance.getDropPoint(GameManager.Instance.dialogId);
            switch (GameManager.Instance.dropTaskGoodsId)
            {
                case GameManager.TASK_GOOD_LEAD:
                    this._goodsMovie1 = ComponentFactory.Instance.creat("asset.trainer8.getLead");
                    if (_gameInfo.selfGamePlayer.mouseState)
                    {
                        _local_2 = "trainer.explain.mouseMode.posGetLead";
                    }
                    else
                    {
                        _local_2 = "trainer.explain.posGetLead";
                    };
                    this._goodsMovie2 = ComponentFactory.Instance.creat("asset.trainer8.getNormal");
                    this._goodsMovie2.x = (_local_1.x + 80);
                    this._goodsMovie2.y = _local_1.y;
                    SoundManager.instance.play("203");
                    LayerManager.Instance.addToLayer(this._goodsMovie2, LayerManager.GAME_UI_LAYER);
                    if (_gameInfo.selfGamePlayer.mouseState)
                    {
                        _local_4 = ComponentFactory.Instance.creatCustomObject("trainer.explain.mouseMode.posGetNormalMode");
                    }
                    else
                    {
                        _local_4 = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetNormalMode");
                    };
                    this._timeoutMark1 = setTimeout(this.tweenTaskGoods, 4200, this._goodsMovie2, _local_4);
                    break;
                case GameManager.TASK_GOOD_PLANE:
                    this._goodsMovie1 = ComponentFactory.Instance.creat("asset.trainer9.getPlane");
                    if (_gameInfo.selfGamePlayer.mouseState)
                    {
                        _local_2 = "trainer.explain.mouseMode.posGetPlane";
                    }
                    else
                    {
                        _local_2 = "trainer.explain.posGetPlane";
                    };
                    break;
            };
            this._goodsMovie1.x = _local_1.x;
            this._goodsMovie1.y = _local_1.y;
            SoundManager.instance.play("203");
            LayerManager.Instance.addToLayer(this._goodsMovie1, LayerManager.GAME_UI_LAYER);
            var _local_3:Point = ComponentFactory.Instance.creatCustomObject(_local_2);
            this._timeoutMark2 = setTimeout(this.tweenTaskGoods, 4200, this._goodsMovie1, _local_3);
        }

        private function tweenTaskGoods(_arg_1:MovieClip, _arg_2:Point):void
        {
            this._dropGoodsTween = null;
            SoundManager.instance.play("204");
            this._dropGoodsTween = TweenLite.to(_arg_1, 0.7, {
                "x":_arg_2.x,
                "y":_arg_2.y,
                "scaleX":0.5,
                "scaleY":0.5,
                "onComplete":this.__onFinishTween,
                "onCompleteParams":[_arg_1]
            });
        }

        private function __onFinishTween(_arg_1:MovieClip):void
        {
            var _local_2:Point;
            var _local_3:Point;
            if (_arg_1)
            {
                if (_arg_1.parent)
                {
                    _arg_1.parent.removeChild(_arg_1);
                };
                _arg_1 = null;
            };
            if (((GameManager.Instance.dropTaskGoodsId == -1) || (!((RoomManager.Instance.current) && (RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)))))
            {
                return;
            };
            switch (GameManager.Instance.dropTaskGoodsId)
            {
                case GameManager.TASK_GOOD_LEAD:
                    this._iconWrapper1 = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer8.getLeadIcon"), true, true);
                    if (_gameInfo.selfGamePlayer.mouseState)
                    {
                        _local_2 = ComponentFactory.Instance.creatCustomObject("trainer.explain.mouseMode.posGetLeadIcon");
                    }
                    else
                    {
                        _local_2 = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetLeadIcon");
                    };
                    GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_LEAD_ICON));
                    this._iconWrapper2 = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer8.getNormalIcon"), true, true);
                    if (_gameInfo.selfGamePlayer.mouseState)
                    {
                        _local_3 = ComponentFactory.Instance.creatCustomObject("trainer.explain.mouseMode.posGetNormalModeIcon");
                    }
                    else
                    {
                        _local_3 = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetNormalModeIcon");
                    };
                    GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_NORMAL_ICON));
                    this._iconWrapper2.movie.x = _local_3.x;
                    this._iconWrapper2.movie.y = _local_3.y;
                    if (((RoomManager.Instance.current) && (RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)))
                    {
                        SoundManager.instance.play("205");
                        LayerManager.Instance.addToLayer(this._iconWrapper2.movie, LayerManager.GAME_UI_LAYER, false);
                    };
                    break;
                case GameManager.TASK_GOOD_PLANE:
                    this._iconWrapper1 = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer9.getPlaneIcon"), true, true);
                    if (_gameInfo.selfGamePlayer.mouseState)
                    {
                        _local_2 = ComponentFactory.Instance.creatCustomObject("trainer.explain.mouseMode.posGetPlaneIcon");
                    }
                    else
                    {
                        _local_2 = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetPlaneIcon");
                    };
                    GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_PLANE_ICON));
                    break;
            };
            this._iconWrapper1.movie.x = _local_2.x;
            this._iconWrapper1.movie.y = _local_2.y;
            if (((RoomManager.Instance.current) && (RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)))
            {
                SoundManager.instance.play("205");
                LayerManager.Instance.addToLayer(this._iconWrapper1.movie, LayerManager.GAME_UI_LAYER, false);
            };
            GameManager.Instance.dropTaskGoodsId = -1;
            GameManager.Instance.dropTaskGoodsNpcId = -1;
            this.setMapFocusLock(false);
            if (GameManager.Instance.dialogId > 0)
            {
                if (DialogManager.Instance.hasDialogs(GameManager.Instance.dialogId))
                {
                    this._timeoutMark1 = setTimeout(this.showDialog, 1000, GameManager.Instance.dialogId);
                };
            };
        }

        private function __dialogEndCallBack(_arg_1:Event):void
        {
            DialogManager.Instance.removeEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            ChatManager.Instance.chatDisabled = false;
            GameManager.Instance.dialogId = -1;
            GameManager.Instance.dropTaskGoodsNpcId = -1;
            if (((DialogManager.Instance.getDropPoint(GameManager.Instance.dialogId)) && (GameManager.Instance.dropTaskGoodsId >= 0)))
            {
                this._timeoutMark1 = setTimeout(this.dropGoods, 500);
            };
        }

        private function __lockScreenHandler(_arg_1:GameEvent):void
        {
            this.setMapFocusLock(_arg_1.data);
        }

        private function setMapFocusLock(_arg_1:Boolean):void
        {
            map.smallMap.allowDrag = (!(_arg_1));
        }

        private function showDialog(_arg_1:int, _arg_2:Function=null):void
        {
            LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox, LayerManager.STAGE_TOP_LAYER);
            DialogManager.Instance.addEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            DialogManager.Instance.showDialog(_arg_1, 2500, false, false, true, 8);
        }

        private function guideTip():Boolean
        {
            var _local_2:Living;
            if (RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM)
            {
                return (false);
            };
            var _local_1:DictionaryData = GameManager.Instance.Current.livings;
            if ((!(_local_1)))
            {
                return (false);
            };
            for each (_local_2 in _local_1)
            {
                if ((_local_2 as Player).playerInfo.Grade <= 15)
                {
                    return (true);
                };
            };
            return (false);
        }

        private function __gameSysMessage(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:String = _local_2.readUTF();
            var _local_5:int = _local_2.readInt();
            switch (_local_3)
            {
                case GameSysMsgType.GET_ITEM_INVENTORY_FULL:
                    MessageTipManager.getInstance().show(String(_local_5), 2);
                    return;
            };
        }

        private function onClick(_arg_1:MouseEvent):void
        {
            var _local_3:DisplayObject;
            this.numCh = 0;
            var _local_2:int;
            while (_local_2 < stage.numChildren)
            {
                _local_3 = StageReferance.stage.getChildAt(_local_2);
                _local_3.visible = true;
                this.numCh++;
                if ((_local_3 is DisplayObjectContainer))
                {
                    this.show(DisplayObjectContainer(_local_3));
                };
                _local_2++;
            };
        }

        private function show(_arg_1:DisplayObjectContainer):void
        {
            var _local_3:DisplayObject;
            var _local_2:int;
            while (_local_2 < _arg_1.numChildren)
            {
                _local_3 = _arg_1.getChildAt(_local_2);
                _local_3.visible = true;
                this.numCh++;
                if ((_local_3 is DisplayObjectContainer))
                {
                    this.show(DisplayObjectContainer(_local_3));
                };
                _local_2++;
            };
        }

        private function __windChanged(_arg_1:GameEvent):void
        {
            _map.wind = _arg_1.data.wind;
            _vane.update(_map.wind, _arg_1.data.isSelfTurn, _arg_1.data.windNumArr);
        }

        override public function getType():String
        {
            return (StateType.FIGHTING);
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            var _local_2:SimpleObject;
            GameManager.Instance.isDieFight = false;
            StageReferance.stage.removeEventListener(MouseEvent.CLICK, this.onClick);
            SoundManager.instance.stopMusic();
            PageInterfaceManager.restorePageTitle();
            if (PlayerManager.Instance.hasTempStyle)
            {
                PlayerManager.Instance.readAllTempStyleEvent();
            };
            _gameInfo.removeEventListener(GameEvent.WIND_CHANGED, this.__windChanged);
            _gameInfo.livings.removeEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            _gameInfo.removeAllMonsters();
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT, this.__shoot);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE, this.__startMove);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE, this.__playerChange);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_BLOOD, this.__playerBlood);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_VANE, this.__changWind);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_HIDE, this.__playerHide);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_NONOLE, this.__playerNoNole);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_PROPERTY, this.__objectSetProperty);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_PROP, this.__playerUsingItem);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_DANDER, this.__dander);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REDUCE_DANDER, this.__reduceDander);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK, this.__changeShootCount);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SUICIDE, this.__suicide);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG, this.__beginShoot);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_BALL, this.__changeBall);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_FROST, this.__forstPlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE, this.__missionOver);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_OVER, this.__gameOver);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_MOVIE, this.__playMovie);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_CHAGEANGLE, this.__livingTurnRotation);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_SOUND, this.__playSound);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_LIVING, this.__addLiving);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_MOVETO, this.__livingMoveto);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_FALLING, this.__livingFalling);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_JUMP, this.__livingJump);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BEAT, this.__livingBeat);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_SAY, this.__livingSay);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING, this.__livingRangeAttacking);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED, this.__livingDirChanged);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT, this.__focusOnObject);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_STATE, this.__changeState);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BARRIER_INFO, this.__barrierInfoHandler);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_MAP_THINGS, this.__addMapThing);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_BOARD_STATE, this.__updatePhysicObject);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR, this.__removePhysicObject);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER, this.__addTipLayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FORBID_DRAG, this.__forbidDragFocus);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOP_LAYER, this.__topLayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTROL_BGM, this.__controlBGM);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE, this.__onLivingBoltmove);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_SHOW_BLOOD, this.__livingShowBlood);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_SHOW_NPC, this.__livingShowNpc);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_TARGET, this.__onChangePlayerTarget);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ACTION_MAPPING, this.__livingActionMapping);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_BUFF, this.__updateBuff);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_BUFF, this.__updatePetBuff);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAMESYSMESSAGE, this.__gameSysMessage);
            PlayerManager.Instance.Self.FightBag.removeEventListener(BagEvent.UPDATE, this.__selfObtainItem);
            PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE, this.__getTempItem);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_PET_SKILL, this.__usePetSkill);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_BOX_SKILL, this.__useFightKitSkillSocket);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DROP_GOODS, this.__onDropItemComplete);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SHOW_DIALOG, this.__getDialogFromServer);
            if (_selfMarkBar)
            {
                _selfMarkBar.removeEventListener(GameEvent.SINGLE_TURN_NOTICE, this.__changePlayerInsingle);
            };
            GameManager.Instance.removeEventListener(GameEvent.LOCK_SCREEN, this.__lockScreenHandler);
            this._gameOverTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__doGameOver);
            this._syncTimer.stop();
            this._syncTimer.removeEventListener(TimerEvent.TIMER, this.__syncLifeTime);
            this._syncTimer = null;
            GameManager.Instance.clearDropData();
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.__mouseDown);
            if (this._turnMovie)
            {
                this._turnMovie.dispose();
            };
            if (this._dropGoodsTween)
            {
                this._dropGoodsTween.kill();
                this._dropGoodsTween = null;
            };
            if (this._timeoutMark1)
            {
                clearTimeout(this._timeoutMark1);
            };
            if (this._timeoutMark2)
            {
                clearTimeout(this._timeoutMark2);
            };
            if (this._goodsMovie1)
            {
                if (this._goodsMovie1.parent)
                {
                    this._goodsMovie1.parent.removeChild(this._goodsMovie1);
                };
                this._goodsMovie1 = null;
            };
            if (this._goodsMovie2)
            {
                if (this._goodsMovie2.parent)
                {
                    this._goodsMovie2.parent.removeChild(this._goodsMovie2);
                };
                this._goodsMovie2 = null;
            };
            if (this._iconWrapper1)
            {
                if (this._iconWrapper1.movie)
                {
                    if (this._iconWrapper1.movie.parent)
                    {
                        this._iconWrapper1.movie.parent.removeChild(this._iconWrapper1.movie);
                    };
                };
            };
            this._iconWrapper1 = null;
            if (this._iconWrapper2)
            {
                if (this._iconWrapper2.movie)
                {
                    if (this._iconWrapper2.movie.parent)
                    {
                        this._iconWrapper2.movie.parent.removeChild(this._iconWrapper2.movie);
                    };
                };
            };
            this._iconWrapper2 = null;
            for each (_local_2 in this._tipItems)
            {
                delete this._tipLayers[_local_2.Id];
                _local_2.dispose();
                _local_2 = null;
            };
            this._tipItems = null;
            if (this._tipLayers)
            {
                if (this._tipLayers.parent)
                {
                    this._tipLayers.parent.removeChild(this._tipLayers);
                };
            };
            this._tipLayers = null;
            _gameInfo.resetBossCardCnt();
            if (this._expView)
            {
                this._expView.removeEventListener(GameEvent.EXPSHOWED, this.__expShowed);
            };
            if (this._settlement)
            {
                ObjectUtils.disposeObject(this._settlement);
                this._settlement = null;
            };
            ObjectUtils.disposeObject(this._settlementPVP);
            this._settlementPVP = null;
            ObjectUtils.disposeObject(this._settlementFightRobot);
            this._settlementFightRobot = null;
            super.leaving(_arg_1);
            if (StateManager.isExitRoom(_arg_1.getType()))
            {
                GameManager.Instance.reset();
                if (_arg_1.getType() != StateType.ARENA)
                {
                    RoomManager.Instance.reset();
                };
            }
            else
            {
                if (((StateManager.isExitGame(_arg_1.getType())) && (!(GameManager.Instance.Current.roomType == RoomInfo.SINGLE_DUNGEON))))
                {
                    GameManager.Instance.reset();
                };
            };
            BallManager.clearAsset();
            BackgoundView.Instance.show();
            GameManager.Instance.hitsNumView = null;
            ObjectUtils.disposeObject(this._hitsNumView);
            this._hitsNumView = null;
        }

        override public function addedToStage():void
        {
            super.addedToStage();
            stage.focus = _map;
        }

        override public function getBackType():String
        {
            if (_gameInfo.roomType == RoomInfo.CHALLENGE_ROOM)
            {
                return (StateType.CHALLENGE_ROOM);
            };
            if (((_gameInfo.roomType == RoomInfo.MATCH_ROOM) || (_gameInfo.roomType == RoomInfo.SINGLE_ROOM)))
            {
                return (StateType.MATCH_ROOM);
            };
            if (_gameInfo.roomType == RoomInfo.FRESHMAN_ROOM)
            {
                if (StartupResourceLoader.firstEnterHall)
                {
                    return (StateType.FRESHMAN_ROOM2);
                };
                return (StateType.FRESHMAN_ROOM1);
            };
            if (_gameInfo.roomType == RoomInfo.HIJACK_CAR)
            {
                return (StateType.MAIN);
            };
            return (StateType.DUNGEON_ROOM);
        }

        protected function __playerChange(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:Living;
            var _local_6:GameLiving;
            var _local_7:GameLiving;
            PageInterfaceManager.restorePageTitle();
            if (_gameInfo.gameMode == GameModeType.SINGLE_DUNGOEN)
            {
                _selfMarkBar.shutdownInSingle();
            }
            else
            {
                _selfMarkBar.shutdown();
            };
            _map.currentFocusedLiving = null;
            var _local_2:int = _arg_1.pkg.extend1;
            var _local_3:Living = _gameInfo.findLiving(_local_2);
            _gameInfo.currentLiving = _local_3;
            if ((_local_3 is TurnedLiving))
            {
                this._ignoreSmallEnemy = false;
                if ((!(_local_3.isLiving)))
                {
                    setCurrentPlayer(null);
                    return;
                };
                if (_local_3.playerInfo == PlayerManager.Instance.Self)
                {
                    PageInterfaceManager.changePageTitle("");
                    if (SavePointManager.Instance.isInSavePoint(19))
                    {
                        GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_PLANE_ICON));
                    };
                };
                _arg_1.executed = false;
                this._soundPlayFlag = true;
                _map.act(new ChangePlayerAction(_map, (_local_3 as TurnedLiving), _arg_1, _arg_1.pkg));
                if (GameManager.Instance.isDieFight)
                {
                    _local_3.doDieFightLight();
                };
            }
            else
            {
                _map.act(new ChangeNpcAction(this, _map, (_local_3 as Living), _arg_1, _arg_1.pkg, this._ignoreSmallEnemy));
                if ((!(this._ignoreSmallEnemy)))
                {
                    this._ignoreSmallEnemy = true;
                };
            };
            if (((_local_3) && (_local_3.playerInfo == PlayerManager.Instance.Self)))
            {
                if (_gameInfo.selfGamePlayer.mouseState)
                {
                    ChatManager.Instance.view.currentType = false;
                };
            }
            else
            {
                if (_gameInfo.selfGamePlayer.mouseState)
                {
                    ChatManager.Instance.view.currentType = true;
                };
            };
            var _local_4:DictionaryData = GameManager.Instance.Current.livings;
            for each (_local_5 in _local_4)
            {
                _local_7 = (this.getGameLivingByID(_local_5.LivingID) as GameLiving);
                if (_local_7)
                {
                    _local_7.fightPowerVisible = false;
                };
            };
            for each (_local_6 in _players)
            {
                if (((_local_6 is GamePlayer) && (GamePlayer(_local_6).gamePet)))
                {
                    GamePlayer(_local_6).gamePet.endShow();
                };
            };
            PrepareShootAction.hasDoSkillAnimation = false;
            GameManager.Instance.isRed = true;
        }

        private function __changePlayerInsingle(_arg_1:GameEvent):void
        {
            SoundManager.instance.play("016");
            if (((!(this._turnMovie)) || (!(this._turnMovie.movie))))
            {
                if (this._turnMovie)
                {
                    ObjectUtils.disposeObject(this._turnMovie);
                    this._turnMovie = null;
                };
                this._turnMovie = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.TurnAsset2")), true, false, true);
                this._turnMovie.movie.mouseChildren = (this._turnMovie.movie.mouseEnabled = false);
                this._turnMovie.movie.x = 440;
                this._turnMovie.movie.y = 180;
                _map.gameView.addChild(this._turnMovie.movie);
            };
            this._turnMovie.gotoAndPlay(1);
        }

        private function __keyDown(_arg_1:KeyboardEvent):void
        {
            _selfMarkBar.setTick(0);
            if (this._turnMovie)
            {
                this._turnMovie.stop();
                this._turnMovie.dispose();
                this._turnMovie = null;
            };
        }

        private function __mouseDown(_arg_1:MouseEvent):void
        {
            this.__keyDown(null);
        }

        private function __playMovie(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:String;
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_2)
            {
                _local_3 = _arg_1.pkg.readUTF();
                _local_2.playMovie(_local_3);
                _map.bringToFront(_local_2);
            };
        }

        private function __livingTurnRotation(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_4:Number;
            var _local_5:String;
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_2)
            {
                _local_3 = int((_arg_1.pkg.readInt() / 10));
                _local_4 = (_arg_1.pkg.readInt() / 10);
                _local_5 = _arg_1.pkg.readUTF();
                _local_2.turnRotation(_local_3, _local_4, _local_5);
                _map.bringToFront(_local_2);
            };
        }

        protected function __addLiving(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_16:Living;
            var _local_17:GameLiving;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readByte();
            var _local_4:int = _local_2.readInt();
            var _local_5:String = _local_2.readUTF();
            var _local_6:String = _local_2.readUTF();
            var _local_7:String = _local_2.readUTF();
            var _local_8:Point = new Point(_local_2.readInt(), _local_2.readInt());
            var _local_9:int = _local_2.readInt();
            var _local_10:int = _local_2.readInt();
            var _local_11:int = _local_2.readInt();
            var _local_12:int = _local_2.readByte();
            var _local_13:int = _local_2.readByte();
            var _local_14:int = _local_2.readInt();
            var _local_15:Boolean = ((_local_13 == 0) ? true : false);
            if (_map.getPhysical(_local_4))
            {
                _map.getPhysical(_local_4).dispose();
            };
            if (((((!(_local_3 == 4)) && (!(_local_3 == 5))) && (!(_local_3 == 6))) && (!(_local_3 == 12))))
            {
                _local_16 = new SmallEnemy(_local_4, _local_11, _local_10);
                _local_16.typeLiving = _local_3;
                _local_16.actionMovieName = _local_6;
                _local_16.direction = _local_12;
                _local_16.pos = _local_8;
                _local_16.name = _local_5;
                _local_16.isBottom = _local_15;
                _local_16.explainType(_local_14);
                _local_16.isShowReadyMC = false;
                _gameInfo.addGamePlayer(_local_16);
                _local_17 = new GameSmallEnemy((_local_16 as SmallEnemy));
                if (_local_9 != _local_16.maxBlood)
                {
                    _local_16.initBlood(_local_9);
                };
            }
            else
            {
                _local_16 = new SimpleBoss(_local_4, _local_11, _local_10);
                _local_16.typeLiving = _local_3;
                _local_16.actionMovieName = _local_6;
                _local_16.direction = _local_12;
                _local_16.pos = _local_8;
                _local_16.name = _local_5;
                _local_16.isBottom = _local_15;
                _local_16.explainType(_local_14);
                _local_16.isShowReadyMC = false;
                _gameInfo.addGamePlayer(_local_16);
                _local_17 = new GameSimpleBoss((_local_16 as SimpleBoss));
                if (_local_9 != _local_16.maxBlood)
                {
                    _local_16.initBlood(_local_9);
                };
            };
            _local_17.name = _local_5;
            _map.addPhysical(_local_17);
            if (_local_7.length > 0)
            {
                _local_17.doAction(_local_7);
            }
            else
            {
                _local_17.doAction(Living.BORN_ACTION);
            };
            _playerThumbnailLController.addLiving(_local_17);
            addChild(_playerThumbnailLController);
            if ((_local_16 is SimpleBoss))
            {
                _map.setCenter(_local_17.x, (_local_17.y - 150), false);
            }
            else
            {
                _map.setCenter(_local_17.x, (_local_17.y - 150), true);
            };
        }

        private function __addTipLayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_10:MovieClip;
            var _local_11:Class;
            var _local_12:MovieClipWrapper;
            var _local_13:SimpleObject;
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:int = _arg_1.pkg.readInt();
            var _local_5:int = _arg_1.pkg.readInt();
            var _local_6:String = _arg_1.pkg.readUTF();
            var _local_7:String = _arg_1.pkg.readUTF();
            var _local_8:int = _arg_1.pkg.readInt();
            var _local_9:int = _arg_1.pkg.readInt();
            if (_local_3 == 10)
            {
                if (ModuleLoader.hasDefinition(_local_6))
                {
                    _local_11 = (ModuleLoader.getDefinition(_local_6) as Class);
                    _local_10 = (new (_local_11)() as MovieClip);
                    _local_12 = new MovieClipWrapper(_local_10, false, true);
                    this.addTipSprite(_local_12.movie);
                    _local_12.gotoAndPlay(1);
                };
            }
            else
            {
                if (this._tipItems[_local_2])
                {
                    _local_13 = (this._tipItems[_local_2] as SimpleObject);
                }
                else
                {
                    _local_13 = new SimpleObject(_local_2, _local_3, _local_6, _local_7);
                    this.addTipSprite(_local_13);
                };
                _local_13.playAction(_local_7);
                this._tipItems[_local_2] = _local_13;
            };
        }

        private function addTipSprite(_arg_1:Sprite):void
        {
            if ((!(this._tipLayers)))
            {
                this._tipLayers = new Sprite();
                this._tipLayers.mouseChildren = (this._tipLayers.mouseEnabled = false);
                addChild(this._tipLayers);
            };
            this._tipLayers.addChild(_arg_1);
        }

        private function __addMapThing(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:int = _arg_1.pkg.readInt();
            var _local_5:int = _arg_1.pkg.readInt();
            var _local_6:String = _arg_1.pkg.readUTF();
            var _local_7:String = _arg_1.pkg.readUTF();
            var _local_8:int = _arg_1.pkg.readInt();
            var _local_9:int = _arg_1.pkg.readInt();
            var _local_10:int = _arg_1.pkg.readInt();
            var _local_11:int = _arg_1.pkg.readInt();
            var _local_12:int = _arg_1.pkg.readInt();
            var _local_13:SimpleObject;
            switch (_local_3)
            {
                case 1:
                    _local_13 = new SimpleBox(_local_2, _local_6);
                    break;
                case 2:
                    _local_13 = new SimpleObject(_local_2, 1, _local_6, _local_7);
                    break;
                default:
                    _local_13 = new SimpleObject(_local_2, 0, _local_6, _local_7, (_local_11 == 6));
            };
            _local_13.x = _local_4;
            _local_13.y = _local_5;
            _local_13.scaleX = _local_8;
            _local_13.scaleY = _local_9;
            _local_13.rotation = _local_10;
            if (_local_3 == 1)
            {
                this.addBox(_local_13);
            };
            this.addEffect(_local_13, _local_12, _local_11);
        }

        private function addBox(_arg_1:SimpleObject):void
        {
            if (GameManager.Instance.Current.selfGamePlayer.isLiving)
            {
                if ((!(this._boxArr)))
                {
                    this._boxArr = new Array();
                };
                this._boxArr.push(_arg_1);
            }
            else
            {
                this.addEffect(_arg_1);
            };
        }

        private function addEffect(_arg_1:SimpleObject, _arg_2:int=0, _arg_3:int=0):void
        {
            switch (_arg_2)
            {
                case -1:
                    this.addStageCurtain(_arg_1);
                    return;
                case 0:
                    _map.addPhysical(_arg_1);
                    if (((_arg_3 > 0) && (!(_arg_3 == 6))))
                    {
                        _map.phyBringToFront(_arg_1);
                    };
                    return;
                default:
                    _map.addObject(_arg_1);
                    this.getGameLivingByID((_arg_2 - 1)).addChild(_arg_1);
            };
        }

        private function __updatePhysicObject(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:SimpleObject = (_map.getPhysical(_local_2) as SimpleObject);
            if ((!(_local_3)))
            {
                _local_3 = (this._tipItems[_local_2] as SimpleObject);
            };
            var _local_4:String = _arg_1.pkg.readUTF();
            if (_local_3)
            {
                _local_3.playAction(_local_4);
            };
            var _local_5:PhyobjEvent = new PhyobjEvent(_local_4);
            dispatchEvent(_local_5);
        }

        private function __applySkill(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            SkillManager.applySkillToLiving(_local_3, _local_4, _local_2);
        }

        private function __removeSkill(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            SkillManager.removeSkillFromLiving(_local_3, _local_4, _local_2);
        }

        private function __removePhysicObject(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:PhysicalObj = this.getGameLivingByID(_local_2);
            var _local_4:Boolean = true;
            if (((_local_3) && (_local_3.parent)))
            {
                _map.removePhysical(_local_3);
            };
            if (((_local_3) && (_local_3.parent)))
            {
                _local_3.parent.removeChild(_local_3);
            };
            if (((_local_4) && (_local_3)))
            {
                if (((!(_local_3 is GameLiving)) || (GameLiving(_local_3).isExist)))
                {
                    _local_3.dispose();
                };
            };
        }

        private function __focusOnObject(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Array = [];
            var _local_4:Object = new Object();
            _local_4.x = _arg_1.pkg.readInt();
            _local_4.y = _arg_1.pkg.readInt();
            _local_3.push(_local_4);
            _map.act(new ViewEachObjectAction(_map, _local_3, _local_2));
        }

        private function __barrierInfoHandler(_arg_1:CrazyTankSocketEvent):void
        {
            barrierInfo = _arg_1;
        }

        private function __livingMoveto(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:Point;
            var _local_4:Point;
            var _local_5:int;
            var _local_6:String;
            var _local_7:String;
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_2)
            {
                _local_3 = new Point(_arg_1.pkg.readInt(), _arg_1.pkg.readInt());
                _local_4 = new Point(_arg_1.pkg.readInt(), _arg_1.pkg.readInt());
                _local_5 = _arg_1.pkg.readInt();
                _local_6 = _arg_1.pkg.readUTF();
                _local_7 = _arg_1.pkg.readUTF();
                _local_2.pos = _local_3;
                _local_2.moveTo(0, _local_4, 0, true, _local_6, _local_5, _local_7);
                _map.bringToFront(_local_2);
            };
        }

        private function __livingFalling(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            var _local_3:Point = new Point(_arg_1.pkg.readInt(), _arg_1.pkg.readInt());
            var _local_4:int = _arg_1.pkg.readInt();
            var _local_5:String = _arg_1.pkg.readUTF();
            var _local_6:int = _arg_1.pkg.readInt();
            if (_local_2)
            {
                _local_2.fallTo(_local_3, _local_4, _local_5, _local_6);
                if ((_local_3.y - _local_2.pos.y) > 50)
                {
                    _map.setCenter(_local_3.x, (_local_3.y - 150), false);
                };
                _map.bringToFront(_local_2);
            };
        }

        private function __livingJump(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            var _local_3:Point = new Point(_arg_1.pkg.readInt(), _arg_1.pkg.readInt());
            var _local_4:int = _arg_1.pkg.readInt();
            var _local_5:String = _arg_1.pkg.readUTF();
            var _local_6:int = _arg_1.pkg.readInt();
            _local_2.jumpTo(_local_3, _local_4, _local_5, _local_6);
            _map.bringToFront(_local_2);
        }

        private function __livingBeat(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_8:Living;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:Object;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Living = _gameInfo.findLiving(_local_2.extend1);
            var _local_4:String = _local_2.readUTF();
            var _local_5:uint = _local_2.readInt();
            var _local_6:Array = new Array();
            var _local_7:uint;
            while (_local_7 < _local_5)
            {
                _local_8 = _gameInfo.findLiving(_local_2.readInt());
                _local_9 = _local_2.readInt();
                _local_10 = _local_2.readInt();
                _local_11 = _local_2.readInt();
                _local_12 = _local_2.readInt();
                _local_13 = new Object();
                _local_13["action"] = _local_4;
                _local_13["target"] = _local_8;
                _local_13["damage"] = _local_9;
                _local_13["targetBlood"] = _local_10;
                _local_13["dander"] = _local_11;
                _local_13["attackEffect"] = _local_12;
                _local_6.push(_local_13);
                if ((((_local_8) && (_local_8.isPlayer())) && (_local_8.isLiving)))
                {
                    (_local_8 as Player).dander = _local_11;
                };
                _local_7++;
            };
            if (_local_3)
            {
                _local_3.beat(_local_6);
            };
        }

        private function __livingSay(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (((!(_local_2)) || (!(_local_2.isLiving))))
            {
                return;
            };
            var _local_3:String = _arg_1.pkg.readUTF();
            var _local_4:int = _arg_1.pkg.readInt();
            _map.bringToFront(_local_2);
            _local_2.say(_local_3, _local_4);
        }

        private function __livingRangeAttacking(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:Living;
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = _arg_1.pkg.readInt();
                _local_5 = _arg_1.pkg.readInt();
                _local_6 = _arg_1.pkg.readInt();
                _local_7 = _arg_1.pkg.readInt();
                _local_8 = _arg_1.pkg.readInt();
                _local_9 = _gameInfo.findLiving(_local_4);
                if (_local_9)
                {
                    _local_9.isHidden = false;
                    _local_9.isFrozen = false;
                    _local_9.updateBlood(_local_6, _local_8);
                    _local_9.showAttackEffect(1);
                    _map.bringToFront(_local_9);
                    if (_local_9.isSelf)
                    {
                        _map.setCenter(_local_9.pos.x, _local_9.pos.y, false);
                    };
                    if (((_local_9.isPlayer()) && (_local_9.isLiving)))
                    {
                        (_local_9 as Player).dander = _local_7;
                    };
                };
                _local_3++;
            };
        }

        private function __livingDirChanged(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_2)
            {
                _local_3 = _arg_1.pkg.readInt();
                _local_2.direction = _local_3;
                _map.bringToFront(_local_2);
            };
        }

        private function __removePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_3:*;
            this._msg = RoomManager.Instance._removeRoomMsg;
            var _local_2:Player = (_arg_1.data as Player);
            if ((_players[_local_2] as GamePlayer))
            {
                _local_3 = (_players[_local_2] as GamePlayer);
            }
            else
            {
                if ((_players[_local_2] as BossPlayer))
                {
                    _local_3 = (_players[_local_2] as BossPlayer);
                };
            };
            if (((_local_3) && (_local_2)))
            {
                if (_map.currentPlayer == _local_2)
                {
                    setCurrentPlayer(null);
                };
                if (_local_2.isSelf)
                {
                    if (((RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM) || (RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM)))
                    {
                        StateManager.setState(StateType.ROOM_LIST);
                    }
                    else
                    {
                        if (RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM)
                        {
                            StateManager.setState(StateType.DUNGEON_LIST);
                        };
                    };
                };
                _map.removePhysical(_local_3);
                if (((_local_3 is GamePlayer) && (_local_3.gamePet)))
                {
                    _map.removePhysical(_local_3.gamePet);
                };
                _local_3.dispose();
                delete _players[_local_2];
            };
        }

        private function __beginShoot(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:GamePlayer;
            if ((((_map.currentPlayer) && (_map.currentPlayer.isPlayer())) && (!(_arg_1.pkg.clientId == _map.currentPlayer.playerInfo.ID))))
            {
                _map.executeAtOnce();
                _map.setCenter(_map.currentPlayer.pos.x, (_map.currentPlayer.pos.y - 150), false);
                if ((_players[_map.currentPlayer] as GamePlayer))
                {
                    _local_2 = _players[_map.currentPlayer];
                    if (_local_2.gamePet)
                    {
                        _local_2.gamePet.prepareForShow();
                    };
                };
            };
            setPropBarClickEnable(false, false);
            PrepareShootAction.hasDoSkillAnimation = false;
        }

        protected function __shoot(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:LocalPlayer;
            var _local_5:Number;
            var _local_6:Boolean;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:Array;
            var _local_11:Array;
            var _local_12:Number;
            var _local_13:uint;
            var _local_14:int;
            var _local_15:Rectangle;
            var _local_16:Array;
            var _local_17:int;
            var _local_18:int;
            var _local_19:int;
            var _local_20:String;
            var _local_21:Bomb;
            var _local_22:int;
            var _local_23:Number;
            var _local_24:Number;
            var _local_25:Number;
            var _local_26:int;
            var _local_27:int;
            var _local_28:int;
            var _local_29:BombAction;
            var _local_30:int;
            var _local_31:Living;
            var _local_32:int;
            var _local_33:int;
            var _local_34:int;
            var _local_35:Object;
            var _local_36:Point;
            var _local_37:Dictionary;
            var _local_38:Bomb;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_3)
            {
                _local_4 = GameManager.Instance.Current.selfGamePlayer;
                _local_5 = (_local_2.readInt() / 10);
                _local_6 = _local_2.readBoolean();
                _local_7 = _local_2.readByte();
                _local_8 = _local_2.readByte();
                _local_9 = _local_2.readByte();
                _local_10 = [_local_6, _local_7, _local_8, _local_9];
                GameManager.Instance.Current.setWind(_local_5, _local_3.isSelf, _local_10);
                _local_11 = new Array();
                _local_12 = _local_2.readInt();
                _local_13 = 0;
                while (_local_13 < _local_12)
                {
                    _local_21 = new Bomb();
                    _local_21.number = _local_2.readInt();
                    _local_21.shootCount = _local_2.readInt();
                    _local_21.IsHole = _local_2.readBoolean();
                    _local_21.Id = _local_2.readInt();
                    _local_21.X = _local_2.readInt();
                    _local_21.Y = _local_2.readInt();
                    _local_21.VX = _local_2.readInt();
                    _local_21.VY = _local_2.readInt();
                    _local_22 = _local_2.readInt();
                    _local_21.Template = BallManager.findBall(_local_22);
                    _local_21.Actions = new Array();
                    _local_21.changedPartical = _local_2.readUTF();
                    _local_23 = (_local_2.readInt() / 1000);
                    _local_24 = (_local_2.readInt() / 1000);
                    _local_25 = (_local_23 * _local_24);
                    _local_21.damageMod = _local_25;
                    _local_21.isSelf = _local_3.isSelf;
                    _local_26 = _local_2.readInt();
                    _local_28 = 0;
                    while (_local_28 < _local_26)
                    {
                        _local_27 = _local_2.readInt();
                        _local_29 = new BombAction(_local_27, _local_2.readInt(), _local_2.readInt(), _local_2.readInt(), _local_2.readInt(), _local_2.readInt(), _local_2.readInt());
                        _local_21.Actions.push(_local_29);
                        if ((((_local_3.isSelf) && (_local_29.type == 2)) && (_local_29.param4 > 0)))
                        {
                            GameManager.Instance.hitsNum = (GameManager.Instance.hitsNum + _local_29.param4);
                        };
                        _local_28++;
                    };
                    if (_local_21.shootCount == 1)
                    {
                        GameManager.Instance.Current.selfGamePlayer.allBombCount = _local_12;
                    };
                    _local_11.push(_local_21);
                    _local_13++;
                };
                _local_3.isReady = false;
                _local_3.shoot(_local_11, _arg_1);
                _local_14 = _local_2.readInt();
                _local_16 = [];
                _local_17 = 0;
                while (_local_17 < _local_14)
                {
                    _local_30 = _local_2.readInt();
                    _local_31 = _gameInfo.findLiving(_local_30);
                    _local_32 = _local_2.readInt();
                    _local_33 = _local_2.readInt();
                    _local_34 = _local_2.readInt();
                    _local_35 = {
                        "target":_local_31,
                        "hp":_local_33,
                        "damage":_local_32,
                        "dander":_local_34
                    };
                    _local_16.push(_local_35);
                    if ((!(_local_15)))
                    {
                        _local_15 = new Rectangle(_local_31.pos.x, _local_31.pos.y);
                    };
                    if (_local_31.pos.x < _local_15.left)
                    {
                        _local_15.left = _local_31.pos.x;
                    }
                    else
                    {
                        if (_local_31.pos.x > _local_15.right)
                        {
                            _local_15.right = _local_31.pos.x;
                        };
                    };
                    if (_local_31.pos.y < _local_15.top)
                    {
                        _local_15.top = _local_31.pos.y;
                    }
                    else
                    {
                        if (_local_31.pos.x > _local_15.bottom)
                        {
                            _local_15.bottom = _local_31.pos.y;
                        };
                    };
                    _local_17++;
                };
                _local_18 = _local_2.readInt();
                _local_19 = _local_2.readInt();
                _local_20 = ("attack" + _local_18.toString());
                if (((!(_local_18 == 0)) && (Player(_local_3).currentPet)))
                {
                    _local_36 = null;
                    if (_local_14 <= 0)
                    {
                        if (_local_11.length == 3)
                        {
                            _local_36 = Bomb(_local_11[1]).target;
                        }
                        else
                        {
                            if (_local_11.length == 1)
                            {
                                _local_36 = Bomb(_local_11[0]).target;
                            };
                        };
                    }
                    else
                    {
                        _local_36 = new Point(((_local_15.left + _local_15.right) / 2), ((_local_15.top + _local_15.bottom) / 2));
                    };
                    _local_37 = Player(_local_3).currentPet.petBeatInfo;
                    _local_37["actionName"] = _local_20;
                    _local_37["targetPoint"] = _local_36;
                    _local_37["targets"] = _local_16;
                    _local_38 = Bomb(_local_11[((_local_11.length == 3) ? 1 : 0)]);
                    _local_38.Actions.push(new BombAction(0, ActionType.PET, _arg_1.pkg.extend1, 0, 0, 0, _local_19));
                };
            };
        }

        private function __suicide(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_2)
            {
                _local_2.die();
            };
        }

        private function __changeBall(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:Player;
            var _local_4:Boolean;
            var _local_5:int;
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (((_local_2) && (_local_2 is Player)))
            {
                _local_3 = (_local_2 as Player);
                _local_4 = _arg_1.pkg.readBoolean();
                _local_5 = _arg_1.pkg.readInt();
                _map.act(new ChangeBallAction(_local_3, _local_4, _local_5));
            };
        }

        private function __playerUsingItem(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_9:DisplayObject;
            var _local_10:String;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readByte();
            var _local_4:int = _local_2.readInt();
            var _local_5:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_local_2.readInt());
            var _local_6:Living = _gameInfo.findLiving(_local_2.extend1);
            var _local_7:Living = _gameInfo.findLiving(_local_2.readInt());
            var _local_8:Boolean = _local_2.readBoolean();
            if (((_local_6) && (_local_5)))
            {
                if (_local_6.isPlayer())
                {
                    if (_local_5.CategoryID == EquipType.Freeze)
                    {
                        (Player(_local_6).skill == -1);
                    };
                    if ((!((_local_6 as Player).isSelf)))
                    {
                        if (EquipType.isHolyGrail(_local_5))
                        {
                            _local_9 = (_local_6 as Player).currentDeputyWeaponInfo.getDeputyWeaponIcon();
                            _local_9.x = (_local_9.x + 7);
                            (_local_6 as Player).useItemByIcon(_local_9);
                        }
                        else
                        {
                            (_local_6 as Player).useItem(_local_5);
                            _local_10 = EquipType.hasPropAnimation(_local_5);
                            if ((((!(_local_10 == null)) && (_local_7)) && (!(_local_7.LivingID == _local_6.LivingID))))
                            {
                                _local_7.showEffect(_local_10);
                            };
                        };
                    };
                };
                if (((_map.currentPlayer) && (_local_7.team == _map.currentPlayer.team)))
                {
                    _map.currentPlayer.addState(_local_5.TemplateID);
                };
                if ((!(_local_7.isLiving)))
                {
                    if (_local_7.isPlayer())
                    {
                        (_local_7 as Player).addState(_local_5.TemplateID);
                    };
                };
                if ((((!(_local_6.isLiving)) && (_local_7)) && (_local_6.team == _local_7.team)))
                {
                    MessageTipManager.getInstance().show(((_local_6.LivingID + "|") + _local_5.TemplateID), 1);
                };
                if (_local_8)
                {
                    MessageTipManager.getInstance().show(String(_local_7.LivingID), 3);
                };
            };
        }

        private function __updateBuff(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_7:FightBuffInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.extend1;
            var _local_4:int = _local_2.readInt();
            var _local_5:Boolean = _local_2.readBoolean();
            var _local_6:Living = _gameInfo.findLiving(_local_3);
            if (((_local_6) && (!(_local_4 == -1))))
            {
                if (_local_5)
                {
                    _local_7 = BuffManager.creatBuff(_local_4);
                    _local_6.addBuff(_local_7);
                }
                else
                {
                    _local_6.removeBuff(_local_4);
                };
            };
        }

        private function __updatePetBuff(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.extend1;
            var _local_4:int = _local_2.readInt();
            var _local_5:String = _local_2.readUTF();
            var _local_6:String = _local_2.readUTF();
            var _local_7:String = _local_2.readUTF();
            var _local_8:String = _local_2.readUTF();
            var _local_9:Boolean = _local_2.readBoolean();
            var _local_10:Living = _gameInfo.findLiving(_local_3);
            var _local_11:FightBuffInfo = new FightBuffInfo(_local_4);
            _local_11.buffPic = _local_7;
            _local_11.buffEffect = _local_8;
            _local_11.type = BuffType.PET_BUFF;
            _local_11.buffName = _local_5;
            _local_11.description = _local_6;
            if (_local_10)
            {
                if (_local_9)
                {
                    _local_10.addPetBuff(_local_11);
                }
                else
                {
                    _local_10.removePetBuff(_local_11);
                };
            };
        }

        private function __startMove(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_8:Array;
            var _local_9:int;
            var _local_10:int;
            var _local_11:PickBoxAction;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Player = _gameInfo.findPlayer(_arg_1.pkg.extend1);
            var _local_4:int = _local_2.readByte();
            var _local_5:Point = new Point(_local_2.readInt(), _local_2.readInt());
            var _local_6:int = _local_2.readByte();
            var _local_7:Boolean = _local_2.readBoolean();
            if (_local_4 == 2)
            {
                _local_8 = [];
                _local_9 = _local_2.readInt();
                _local_10 = 0;
                while (_local_10 < _local_9)
                {
                    _local_11 = new PickBoxAction(_local_2.readInt(), _local_2.readInt());
                    _local_8.push(_local_11);
                    _local_10++;
                };
                if (_local_3)
                {
                    _local_3.playerMoveTo(_local_4, _local_5, _local_6, _local_7, _local_8);
                };
            }
            else
            {
                if (_local_3)
                {
                    _local_3.playerMoveTo(_local_4, _local_5, _local_6, _local_7);
                };
            };
        }

        private function __onLivingBoltmove(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_3)
            {
                _local_3.pos = new Point(_local_2.readInt(), _local_2.readInt());
            };
        }

        private function __playerBlood(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readByte();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            var _local_6:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_6)
            {
                _local_6.updateBlood(_local_4, _local_3, _local_5);
            };
        }

        private function __changWind(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            _map.wind = (_local_2.readInt() / 10);
            var _local_3:Boolean = _local_2.readBoolean();
            var _local_4:int = _local_2.readByte();
            var _local_5:int = _local_2.readByte();
            var _local_6:int = _local_2.readByte();
            var _local_7:Array = new Array();
            _local_7 = [_local_3, _local_4, _local_5, _local_6];
            _vane.update(_map.wind, false, _local_7);
        }

        private function __playerNoNole(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_2)
            {
                _local_2.isNoNole = _arg_1.pkg.readBoolean();
            };
        }

        private function __onChangePlayerTarget(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            if (_local_2 == 0)
            {
                if (_playerThumbnailLController)
                {
                    _playerThumbnailLController.currentBoss = null;
                };
                return;
            };
            var _local_3:Living = _gameInfo.findLiving(_local_2);
            _playerThumbnailLController.currentBoss = _local_3;
        }

        private function __objectSetProperty(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:GameLiving = (this.getGameLivingByID(_arg_1.pkg.extend1) as GameLiving);
            if ((!(_local_2)))
            {
                return;
            };
            var _local_3:String = _arg_1.pkg.readUTF();
            var _local_4:String = _arg_1.pkg.readUTF();
            this.setProperty(_local_2, _local_3, _local_4);
        }

        private function setProperty(_arg_1:GameLiving, _arg_2:String, _arg_3:String):void
        {
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:Living;
            var _local_4:StringObject = new StringObject(_arg_3);
            switch (_arg_2)
            {
                case "system":
                    if (_arg_1)
                    {
                        _local_5 = 0;
                        _local_6 = _local_4.getBoolean();
                        _local_7 = _arg_1.info;
                        _local_7.LockType = _local_5;
                        _local_7.LockState = _local_6;
                        if (_arg_1.info.isSelf)
                        {
                            GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _local_6;
                            GameManager.Instance.Current.selfGamePlayer.lockFly = _local_6;
                            GameManager.Instance.Current.selfGamePlayer.lockSpellKill = _local_6;
                            GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = (!(_local_6));
                            GameManager.Instance.Current.selfGamePlayer.weaponPropEnbled = (!(_local_6));
                            GameManager.Instance.Current.selfGamePlayer.customPropEnabled = (!(_local_6));
                            GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = (!(_local_6));
                        };
                    };
                    return;
                case "silencedSpecial":
                    if (_arg_1)
                    {
                        _local_5 = 3;
                        _local_6 = _local_4.getBoolean();
                        _local_7 = _arg_1.info;
                        _local_7.LockType = _local_5;
                        _local_7.LockState = _local_6;
                        if (_arg_1.info.isSelf)
                        {
                            GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _local_6;
                            GameManager.Instance.Current.selfGamePlayer.lockFly = _local_6;
                            GameManager.Instance.Current.selfGamePlayer.lockSpellKill = _local_6;
                            GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = (!(_local_6));
                            GameManager.Instance.Current.selfGamePlayer.weaponPropEnbled = (!(_local_6));
                            GameManager.Instance.Current.selfGamePlayer.customPropEnabled = (!(_local_6));
                        };
                    };
                    return;
                case "silenced":
                    if (_arg_1)
                    {
                        _local_5 = 1;
                        _local_6 = _local_4.getBoolean();
                        _local_7 = _arg_1.info;
                        _local_7.LockType = _local_5;
                        _local_7.LockState = _local_6;
                        if (_arg_1.info.isSelf)
                        {
                            GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = (!(_local_6));
                            GameManager.Instance.Current.selfGamePlayer.customPropEnabled = (!(_local_6));
                            GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _local_6;
                        };
                    };
                    return;
                case "nofly":
                    _local_5 = 2;
                    _local_6 = _local_4.getBoolean();
                    _local_7 = _arg_1.info;
                    _local_7.LockType = _local_5;
                    _local_7.LockState = _local_6;
                    if (_arg_1.info.isSelf)
                    {
                        GameManager.Instance.Current.selfGamePlayer.lockFly = _local_6;
                    };
                    return;
                case "silenceMany":
                    _local_5 = 1;
                    _local_6 = _local_4.getBoolean();
                    _local_7 = _arg_1.info;
                    if (_local_6)
                    {
                        _local_7.addBuff(BuffManager.creatBuff(BuffType.LockState));
                    }
                    else
                    {
                        _local_7.removeBuff(BuffType.LockState);
                    };
                    if (_arg_1.info.isSelf)
                    {
                        GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _local_6;
                        GameManager.Instance.Current.selfGamePlayer.lockFly = _local_6;
                        GameManager.Instance.Current.selfGamePlayer.lockRightProp = _local_6;
                    };
                    return;
                case "hideBossThumbnail":
                    if (_arg_1)
                    {
                        _playerThumbnailLController.removeThumbnailContainer();
                    };
                    return;
                case "diefight":
                    if (_arg_1)
                    {
                        GameManager.Instance.isDieFight = true;
                        _local_7 = _arg_1.info;
                        _local_7.DieFightBuffEnabled = _local_4.getBoolean();
                    };
                default:
                    _arg_1.setProperty(_arg_2, _arg_3);
            };
        }

        private function __usePetSkill(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.extend1;
            var _local_4:int = _local_2.readInt();
            var _local_5:Boolean = _local_2.readBoolean();
            var _local_6:Player = _gameInfo.findPlayer(_local_3);
            if ((((_local_6) && (_local_6.currentPet)) && (_local_5)))
            {
                _local_6.usePetSkill(_local_4, _local_5);
                if (PetSkillManager.instance.getSkillByID(_local_4).BallType == PetSkillInfo.BALL_TYPE_2)
                {
                    _local_6.isAttacking = false;
                    GameManager.Instance.Current.selfGamePlayer.beginShoot();
                };
            };
            if ((!(_local_5)))
            {
                GameManager.Instance.dispatchEvent(new LivingEvent(LivingEvent.PETSKILL_USED_FAIL));
            };
        }

        private function __playerHide(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_2)
            {
                _local_2.isHidden = _arg_1.pkg.readBoolean();
            };
        }

        private function __gameOver(_arg_1:CrazyTankSocketEvent):void
        {
            this.gameOver();
            _map.act(new GameOverAction(_map, _arg_1, this.showExpView));
        }

        private function __missionOver(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:String;
            SoundManager.instance.stopMusic();
            this._gameOverTimer.start();
            this._missionAgain = new MissionAgainInfo();
            this._missionAgain.value = _gameInfo.missionInfo.tryagain;
            var _local_2:DictionaryData = RoomManager.Instance.current.players;
            for (_local_3 in _local_2)
            {
                if (RoomPlayer(_local_2[_local_3]).isHost)
                {
                    this._missionAgain.host = RoomPlayer(_local_2[_local_3]).playerInfo.NickName;
                };
            };
            _map.act(new MissionOverAction(_map, _arg_1, this.showExpView));
        }

        private function __doGameOver(_arg_1:TimerEvent):void
        {
            this._gameOverTimer.stop();
            this._gameOverTimer.reset();
            this.gameOver();
        }

        override protected function gameOver():void
        {
            PageInterfaceManager.restorePageTitle();
            super.gameOver();
            KeyboardManager.getInstance().isStopDispatching = true;
        }

        private function showTryAgain():void
        {
            var _local_1:TryAgain = new TryAgain(this._missionAgain);
            _local_1.addEventListener(GameEvent.TRYAGAIN, this.__tryAgain);
            _local_1.addEventListener(GameEvent.GIVEUP, this.__giveup);
            _local_1.addEventListener(GameEvent.TIMEOUT, this.__tryAgainTimeOut);
            _local_1.show();
            addChild(_local_1);
        }

        private function __tryAgainTimeOut(_arg_1:GameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(GameEvent.TRYAGAIN, this.__tryAgain);
            _arg_1.currentTarget.removeEventListener(GameEvent.GIVEUP, this.__giveup);
            _arg_1.currentTarget.removeEventListener(GameEvent.TIMEOUT, this.__tryAgainTimeOut);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            if (this._expView)
            {
                this._expView.close();
            };
            this._expView = null;
            if (((RoomManager.Instance.current) && (RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)))
            {
                StateManager.setState(StateType.SINGLEDUNGEON);
            };
        }

        private function resetBossPlayerStatues():void
        {
            if (GameManager.Instance.Current)
            {
                GameManager.Instance.Current.selfGamePlayer.typeLiving = LivingTypesEnum.NORMAL_PLAYER;
            };
            if (GameManager.Instance.Current.selfGamePlayer.isBoss)
            {
                SingleDungeonManager.Instance.setBossPetNull();
            };
        }

        private function showExpView():void
        {
            var _local_1:GameInfo = GameManager.Instance.Current;
            var _local_2:RoomInfo = RoomManager.Instance.current;
            if (_local_1.self.isBoss)
            {
                this.resetBossPlayerStatues();
            };
            if (ChatManager.Instance.input.parent)
            {
                ChatManager.Instance.switchVisible();
            };
            ChatManager.Instance.state = ChatManager.CHAT_GAMEOVER_STATE;
            MenoryUtil.clearMenory();
            if (_local_1.roomType == 14)
            {
                StateManager.setState(StateType.WORLDBOSS_ROOM);
                return;
            };
            var _local_3:int = GameManager.Instance.Current.roomType;
            var _local_4:DungeonInfo = MapManager.getDungeonInfo(_local_2.mapId);
            if (((((((((!(_local_3 == RoomInfo.SINGLE_DUNGEON)) && (!(_local_3 == RoomInfo.CHALLENGE_ROOM))) && (!(_local_3 == RoomInfo.SINGLE_ROOM))) && (!(_local_3 == RoomInfo.MATCH_ROOM))) && (!(_local_3 == RoomInfo.CONSORTION_MONSTER))) && (!(_local_3 == RoomInfo.HIJACK_CAR))) && (!(_local_3 == RoomInfo.ARENA))) && (!(_local_3 == RoomInfo.FIGHT_ROBOT))))
            {
                this._expView = new ExpView(_map.mapBitmap);
                this._expView.addEventListener(GameEvent.EXPSHOWED, this.__expShowed);
                addChild(this._expView);
                this._expView.show();
            }
            else
            {
                if (((_local_3 == RoomInfo.SINGLE_DUNGEON) || (_local_3 == RoomInfo.CONSORTION_MONSTER)))
                {
                    this.showRemoveEffect();
                    LayerManager.Instance.clearnGameDynamic();
                    LayerManager.Instance.clearnStageDynamic();
                    if (((!(_gameInfo.selfGamePlayer.isWin)) && (this._missionAgain.value > 0)))
                    {
                        this.showTryAgain();
                    }
                    else
                    {
                        this.showSettleMentView();
                    };
                }
                else
                {
                    this.showRemoveEffect();
                    LayerManager.Instance.clearnGameDynamic();
                    LayerManager.Instance.clearnStageDynamic();
                    if (_local_3 == RoomInfo.ARENA)
                    {
                        ArenaManager.instance.enter(1);
                    }
                    else
                    {
                        if (_local_3 == RoomInfo.FIGHT_ROBOT)
                        {
                            this.showSettleMentViewFightRobot();
                        }
                        else
                        {
                            this.showSettleMentViewPVP();
                        };
                    };
                };
            };
        }

        private function showSettleMentView():void
        {
            this._settlement = new SettlementView();
            addChild(this._settlement);
        }

        private function showSettleMentViewFightRobot():void
        {
            this._settlementFightRobot = new SettlementViewFightRobot();
            addChild(this._settlementFightRobot);
        }

        private function showSettleMentViewPVP():void
        {
            this._settlementPVP = new SettlementViewPVP();
            addChild(this._settlementPVP);
        }

        private function showRemoveEffect():void
        {
            var t1:TweenLite;
            var t2:TweenLite;
            var t3:TweenLite;
            var t5:TweenLite;
            var t4:TweenLite;
            t1 = TweenLite.to(_vane, 0.6, {
                "y":-86,
                "ease":Sine.easeIn,
                "onComplete":function ():void
                {
                    t1.kill();
                }
            });
            t2 = TweenLite.to(_playerThumbnailLController, 0.6, {
                "y":-86,
                "ease":Sine.easeIn,
                "onComplete":function ():void
                {
                    t2.kill();
                }
            });
            t3 = TweenLite.to(_map.smallMap, 0.6, {
                "x":1114,
                "ease":Sine.easeIn,
                "onComplete":function ():void
                {
                    t3.kill();
                }
            });
            if (currentControllState)
            {
                t4 = TweenLite.to(currentControllState, 0.6, {
                    "y":662,
                    "alpha":0,
                    "ease":Sine.easeIn,
                    "onComplete":function ():void
                    {
                        t4.kill();
                    }
                });
            };
            t5 = TweenLite.to(_leftPlayerView, 0.65, {
                "x":-205,
                "ease":Sine.easeIn,
                "onComplete":function ():void
                {
                    t5.kill();
                }
            });
        }

        private function __expShowed(_arg_1:GameEvent):void
        {
            var _local_2:Living;
            var _local_3:Living;
            this._expView.removeEventListener(GameEvent.EXPSHOWED, this.__expShowed);
            for each (_local_2 in _gameInfo.livings.list)
            {
                if (_local_2.isSelf)
                {
                    if (((Player(_local_2).isWin) && (this._missionAgain)))
                    {
                        this._missionAgain.win = true;
                    };
                    if (((Player(_local_2).hasLevelAgain) && (this._missionAgain)))
                    {
                        this._missionAgain.hasLevelAgain = true;
                    };
                };
            };
            for each (_local_3 in _gameInfo.viewers.list)
            {
                if (_local_3.isSelf)
                {
                    if (((Player(_local_3).isWin) && (this._missionAgain)))
                    {
                        this._missionAgain.win = true;
                    };
                    if (((Player(_local_3).hasLevelAgain) && (this._missionAgain)))
                    {
                        this._missionAgain.hasLevelAgain = true;
                    };
                };
            };
            if (((GameManager.isDungeonRoom(_gameInfo)) && (_gameInfo.missionInfo.tryagain > 0)))
            {
                if (((RoomManager.Instance.current.selfRoomPlayer.isViewer) && (!(this._missionAgain.win))))
                {
                    this.showTryAgain();
                    if (this._expView)
                    {
                        this._expView.visible = false;
                    };
                }
                else
                {
                    if (((RoomManager.Instance.current.selfRoomPlayer.isViewer) && (this._missionAgain.win)))
                    {
                        if (this._expView)
                        {
                            this._expView.close();
                        };
                        this._expView = null;
                    }
                    else
                    {
                        if ((!(_gameInfo.selfGamePlayer.isWin)))
                        {
                            this.showTryAgain();
                            if (this._expView)
                            {
                                this._expView.visible = false;
                            };
                        }
                        else
                        {
                            this._expView.showCard();
                            this._expView = null;
                        };
                    };
                };
            }
            else
            {
                if (RoomManager.Instance.current.selfRoomPlayer.isViewer)
                {
                    this._expView.close();
                    this._expView = null;
                }
                else
                {
                    if (RoomManager.Instance.current.type == RoomInfo.HIJACK_CAR)
                    {
                        this._expView.close();
                        this._expView = null;
                    }
                    else
                    {
                        this._expView.showCard();
                        this._expView = null;
                    };
                };
            };
        }

        private function __giveup(_arg_1:GameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(GameEvent.TRYAGAIN, this.__tryAgain);
            _arg_1.currentTarget.removeEventListener(GameEvent.GIVEUP, this.__giveup);
            _arg_1.currentTarget.removeEventListener(GameEvent.TIMEOUT, this.__tryAgainTimeOut);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            if (RoomManager.Instance.current.selfRoomPlayer.isHost)
            {
                GameInSocketOut.sendMissionTryAgain(GameManager.MissionGiveup, true);
            };
            if (this._expView)
            {
                this._expView.close();
                this._expView = null;
            };
            if (RoomManager.Instance.current)
            {
                if (RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
                {
                    StateManager.setState(StateType.SINGLEDUNGEON);
                }
                else
                {
                    if (RoomManager.Instance.current.type == RoomInfo.CONSORTION_MONSTER)
                    {
                        StateManager.setState(StateType.CONSORTIA);
                    };
                };
            };
        }

        private function __tryAgain(_arg_1:GameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(GameEvent.TRYAGAIN, this.__tryAgain);
            _arg_1.currentTarget.removeEventListener(GameEvent.GIVEUP, this.__giveup);
            _arg_1.currentTarget.removeEventListener(GameEvent.TIMEOUT, this.__tryAgainTimeOut);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            if (((!(RoomManager.Instance.current.selfRoomPlayer.isViewer)) || (GameManager.Instance.TryAgain == GameManager.MissionAgain)))
            {
                GameManager.Instance.Current.hasNextMission = true;
            };
            if (this._expView)
            {
                this._expView.close();
                this._expView = null;
            };
            if (RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
            {
                GameInSocketOut.sendGameMissionStart(true);
                GameManager.Instance.addEventListener(GameManager.START_LOAD, this.__startLoading);
            };
        }

        protected function __startLoading(_arg_1:Event):void
        {
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

        private function __dander(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (((_local_2) && (_local_2 is Player)))
            {
                _local_3 = _arg_1.pkg.readInt();
                (_local_2 as Player).dander = _local_3;
            };
        }

        private function __reduceDander(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:int;
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (((_local_2) && (_local_2 is Player)))
            {
                _local_3 = _arg_1.pkg.readInt();
                (_local_2 as Player).reduceDander(_local_3);
            };
        }

        private function __changeState(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_2)
            {
                _local_2.State = _arg_1.pkg.readInt();
                _map.setCenter(_local_2.pos.x, _local_2.pos.y, true);
            };
        }

        private function __selfObtainItem(_arg_1:BagEvent):void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:PropInfo;
            var _local_4:AutoDisappear;
            var _local_5:AutoDisappear;
            var _local_6:AutoDisappear;
            var _local_7:MovieClipWrapper;
            for each (_local_2 in _arg_1.changedSlots)
            {
                _local_3 = new PropInfo(_local_2);
                _local_3.Place = _local_2.Place;
                if (PlayerManager.Instance.Self.FightBag.getItemAt(_local_2.Place))
                {
                    _local_4 = new AutoDisappear(ComponentFactory.Instance.creatBitmap("asset.game.getPropBgAsset"), 3);
                    _local_4.x = ((_vane.x - (_local_4.width / 2)) + 48);
                    _local_4.y = ((_selfMarkBar.y + _selfMarkBar.height) + 70);
                    LayerManager.Instance.addToLayer(_local_4, LayerManager.GAME_DYNAMIC_LAYER, false);
                    _local_5 = new AutoDisappear(PropItemView.createView(_local_3.Template.Pic, 62, 62), 3);
                    _local_5.x = ((_vane.x - (_local_5.width / 2)) + 47);
                    _local_5.y = ((_selfMarkBar.y + _selfMarkBar.height) + 70);
                    LayerManager.Instance.addToLayer(_local_5, LayerManager.GAME_DYNAMIC_LAYER, false);
                    _local_6 = new AutoDisappear(ComponentFactory.Instance.creatBitmap("asset.game.getPropCiteAsset"), 3);
                    _local_6.x = ((_vane.x - (_local_6.width / 2)) + 45);
                    _local_6.y = ((_selfMarkBar.y + _selfMarkBar.height) + 70);
                    LayerManager.Instance.addToLayer(_local_6, LayerManager.GAME_DYNAMIC_LAYER, false);
                    _local_7 = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.zxcTip"), true, true);
                    _local_7.movie.x = (_local_7.movie.x + ((_local_7.movie.width * _local_2.Place) - (this.ZXC_OFFSET * _local_2.Place)));
                    LayerManager.Instance.addToLayer(_local_7.movie, LayerManager.GAME_UI_LAYER, false);
                };
            };
        }

        private function __getTempItem(_arg_1:BagEvent):void
        {
            var _local_2:Boolean = GameManager.Instance.selfGetItemShowAndSound(_arg_1.changedSlots);
            if (((_local_2) && (this._soundPlayFlag)))
            {
                this._soundPlayFlag = false;
                SoundManager.instance.play("1001");
            };
        }

        private function __forstPlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.extend1);
            if (_local_2)
            {
                _local_2.isFrozen = _arg_1.pkg.readBoolean();
            };
        }

        private function __changeShootCount(_arg_1:CrazyTankSocketEvent):void
        {
            _gameInfo.selfGamePlayer.shootCount = _arg_1.pkg.readByte();
        }

        private function __playSound(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:String = _arg_1.pkg.readUTF();
            SoundManager.instance.initSound(_local_2);
            SoundManager.instance.play(_local_2);
        }

        private function __controlBGM(_arg_1:CrazyTankSocketEvent):void
        {
            if (_arg_1.pkg.readBoolean())
            {
                SoundManager.instance.resumeMusic();
            }
            else
            {
                SoundManager.instance.pauseMusic();
            };
        }

        private function __forbidDragFocus(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            _map.smallMap.allowDrag = _local_2;
        }

        override protected function defaultForbidDragFocus():void
        {
            _map.smallMap.allowDrag = true;
        }

        private function __topLayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Living = _gameInfo.findLiving(_arg_1.pkg.readInt());
            if (_local_2)
            {
                _map.bringToFront(_local_2);
            };
        }

        private function __loadResource(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:GameNeedMovieInfo;
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = new GameNeedMovieInfo();
                _local_4.type = _arg_1.pkg.readInt();
                _local_4.path = _arg_1.pkg.readUTF();
                _local_4.classPath = _arg_1.pkg.readUTF();
                _local_4.startLoad();
                _local_3++;
            };
        }

        private function __livingShowBlood(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = Boolean(_arg_1.pkg.readInt());
            (_map.getPhysical(_local_2) as GameLiving).showBlood(_local_3);
        }

        private function __livingShowNpc(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:Boolean = Boolean(_arg_1.pkg.readInt());
            (_map.getPhysical(_local_2) as GameLiving).showNpc(_local_3);
        }

        private function __livingActionMapping(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:String = _arg_1.pkg.readUTF();
            var _local_4:String = _arg_1.pkg.readUTF();
            if (_map.getPhysical(_local_2))
            {
                _map.getPhysical(_local_2).setActionMapping(_local_3, _local_4);
            };
        }

        private function getGameLivingByID(_arg_1:int):PhysicalObj
        {
            if ((!(_map)))
            {
                return (null);
            };
            return (_map.getPhysical(_arg_1));
        }

        private function addStageCurtain(obj:SimpleObject):void
        {
            obj.movie.addEventListener("playEnd", function ():void
            {
                obj.movie.stop();
                if (obj.parent)
                {
                    obj.parent.removeChild(obj);
                };
                obj.dispose();
                obj = null;
            });
            addChild(obj);
        }

        private function __onDropItemComplete(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:DisplayObject;
            var _local_12:Point;
            var _local_13:Point;
            var _local_14:DropGoods;
            var _local_15:Class;
            var _local_16:ItemTemplateInfo;
            var _local_17:BaseCell;
            var _local_2:PackageIn = _arg_1.pkg;
            if (_local_2.bytesAvailable < 1)
            {
                return;
            };
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                _local_7 = _local_2.readInt();
                _local_8 = 0;
                while (_local_8 < _local_7)
                {
                    _local_9 = _local_2.readInt();
                    _local_10 = _local_2.readInt();
                    _local_9 = EquipType.filterEquiqItemId(_local_9);
                    if (_local_9 == -400)
                    {
                        if (ModuleLoader.hasDefinition("asset.game.dropEffect.magicSoul"))
                        {
                            _local_15 = ModuleLoader.getDefinition("asset.game.dropEffect.magicSoul");
                            _local_11 = new (_local_15)();
                        };
                    }
                    else
                    {
                        _local_16 = ItemManager.Instance.getTemplateById(_local_9);
                        _local_17 = new BaseCell(new Sprite(), _local_16, false, false);
                        _local_17.setContentSize(40, 40);
                        _local_11 = _local_17;
                    };
                    _local_12 = new Point(_local_3, _local_4);
                    if (_selfGamePlayer)
                    {
                        _local_13 = new Point(_selfGamePlayer.x, (_selfGamePlayer.y - 30));
                    }
                    else
                    {
                        if (_selfTurnedLiving)
                        {
                            _local_13 = new Point(_selfTurnedLiving.x, (_selfTurnedLiving.y - 30));
                        };
                    };
                    if (_local_9 == EquipType.GOLD)
                    {
                        GameManager.Instance.dropGlod = (GameManager.Instance.dropGlod + _local_10);
                    }
                    else
                    {
                        GameManager.Instance.setDropData(_local_9, _local_10);
                    };
                    _local_14 = new DropGoods(this.map, _local_11, _local_12, _local_13, _local_10);
                    GameManager.Instance.dropGoodslist.push(_local_14);
                    _local_8++;
                };
                _local_6++;
            };
        }

        private function __useFightKitSkillSocket(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:int;
            var _local_5:Dictionary;
            var _local_6:int;
            var _local_7:int;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            if (_local_3 != 0)
            {
                _local_4 = _local_2.readInt();
                this._enermy = new Array();
                _local_5 = _map.getPhysicalAll();
                _local_6 = 0;
                while (_local_6 < _local_4)
                {
                    _local_7 = _local_2.readInt();
                    this._enermy[_local_6] = _local_5[_local_7];
                    _local_6++;
                };
                this._enermyNum = 0;
                this._timer = new Timer(200, this._enermy.length);
                this._timer.start();
                this._timer.addEventListener(TimerEvent.TIMER, this.__skillTimer);
                if (((((_map) && (_map.currentPlayer)) && (_map.currentPlayer.playerInfo)) && (_map.currentPlayer.playerInfo.ID == PlayerManager.Instance.Self.ID)))
                {
                    PlayerManager.Instance.Self.dispatchEvent(new LivingEvent(LivingEvent.FIGHT_TOOL_BOX_CHANGED));
                };
            };
        }

        private function __skillTimer(_arg_1:TimerEvent):void
        {
            if (this._enermyNum >= this._enermy.length)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.__skillTimer);
                this._timer = null;
                this._enermy = null;
                return;
            };
            _map.animateSet.addAnimation(new ShockMapAnimation(this._enermy[this._enermyNum], 14));
            this._enermy[this._enermyNum].playFightToolBoxSkill();
            map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this._enermy[this._enermyNum], 10, 0));
            this._enermyNum++;
        }

        private function __petReduce(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.extend1;
            var _local_3:Living = _gameInfo.findLiving(_local_2);
            var _local_4:int = _arg_1.pkg.readInt();
            var _local_5:GameLiving = (this.getGameLivingByID(_local_3.LivingID) as GameLiving);
            var _local_6:ShootPercentView = new ShootPercentView(_local_4, 21);
            _local_6.x = ((_local_5.x - 50) + _local_5.offset());
            _local_6.y = ((_local_5.y - 50) - _local_5.offset());
            _map.addToPhyLayer(_local_6);
            GameManager.Instance.petReduceList.push(_local_6);
        }


    }
}//package game.view

