package game.view
{
   import SingleDungeon.SingleDungeonManager;
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.BuffType;
   import ddt.data.EquipType;
   import ddt.data.FightBuffInfo;
   import ddt.data.PropInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.map.DungeonInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.events.PhyobjEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.BallManager;
   import ddt.manager.BuffManager;
   import ddt.manager.ChatManager;
   import ddt.manager.DialogManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PageInterfaceManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SkillManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.StatisticManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.MenoryUtil;
   import ddt.view.BackgoundView;
   import ddt.view.PropItemView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.TryAgain;
   import game.actions.ChangeBallAction;
   import game.actions.ChangeNpcAction;
   import game.actions.GameOverAction;
   import game.actions.MissionOverAction;
   import game.actions.MultiChangePlayerAction;
   import game.actions.MultiPlaySpellSkillAction;
   import game.actions.MultiPrepareShootAction;
   import game.actions.MultiRemovePlayerAction;
   import game.actions.MultiShootAction;
   import game.actions.PickBoxAction;
   import game.actions.PrepareShootAction;
   import game.actions.ShootBombAction;
   import game.actions.UpdateStateAction;
   import game.actions.ViewEachObjectAction;
   import game.animations.AnimationLevel;
   import game.animations.AnimationSet;
   import game.animations.PhysicalObjFocusAnimation;
   import game.animations.ShockMapAnimation;
   import game.model.GameInfo;
   import game.model.GameModeType;
   import game.model.GameNeedMovieInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.MissionAgainInfo;
   import game.model.Player;
   import game.model.SimpleBoss;
   import game.model.SmallEnemy;
   import game.model.TurnedLiving;
   import game.objects.ActionType;
   import game.objects.BombAction;
   import game.objects.DamageObject;
   import game.objects.GameLiving;
   import game.objects.GamePlayer;
   import game.objects.GameSimpleBoss;
   import game.objects.GameSmallEnemy;
   import game.objects.GameSysMsgType;
   import game.objects.GameTurnedLiving;
   import game.objects.LivingTypesEnum;
   import game.objects.SimpleBox;
   import game.objects.SimpleObject;
   import game.view.effects.ShootPercentView;
   import game.view.experience.ExpView;
   import game.view.prop.PlayerUsePropView;
   import game.view.settlement.SettlementView;
   import game.view.settlement.SettlementViewFightRobot;
   import game.view.settlement.SettlementViewPVP;
   import game.view.tool.DamageStasticView;
   import org.aswing.KeyboardManager;
   import pet.date.PetSkillInfo;
   import phy.object.PhysicalObj;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.data.StringObject;
   import road7th.utils.AutoDisappear;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   
   public class MultiShootGameView extends GameViewBase
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
      
      private var _damageStasticView:DamageStasticView;
      
      private var _playerUsePropView:PlayerUsePropView;
      
      private var _gameOverTimer:Timer;
      
      private var _playerRemoveList:DictionaryData;
      
      private var mInfoDic:DictionaryData;
      
      private var mBombListDic:DictionaryData;
      
      private var mShootEventDic:DictionaryData;
      
      private var _petSkillListDic:DictionaryData;
      
      private var _livingBloodDic:DictionaryData;
      
      private var _damageTypeDic:DictionaryData;
      
      private var numCh:Number;
      
      private var _soundPlayFlag:Boolean;
      
      private var _ignoreSmallEnemy:Boolean;
      
      private var _turnMovie:MovieClipWrapper;
      
      private var _boxArr:Array;
      
      private var _missionAgain:MissionAgainInfo;
      
      protected var _expView:ExpView;
      
      private var _settlement:SettlementView;
      
      private var _settlementPVP:SettlementViewPVP;
      
      private var _settlementFightRobot:SettlementViewFightRobot;
      
      private var _timer:Timer;
      
      private var _enermy:Array;
      
      public function MultiShootGameView()
      {
         this._gameOverTimer = new Timer(100);
         this._playerRemoveList = new DictionaryData();
         this.mInfoDic = new DictionaryData();
         this.mBombListDic = new DictionaryData();
         this.mShootEventDic = new DictionaryData();
         this._petSkillListDic = new DictionaryData();
         this._livingBloodDic = new DictionaryData();
         this._damageTypeDic = new DictionaryData();
         this._timer = new Timer(200);
         this._enermy = [];
         super();
      }
      
      override protected function needLeftPlayerView() : Boolean
      {
         return false;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this._damageStasticView = ComponentFactory.Instance.creat("ddt.game.damageView");
         addChild(this._damageStasticView);
         this._playerUsePropView = ComponentFactory.Instance.creat("game.view.prop.PlayerUsePropView",[_gameInfo.teams[1]]);
         addChild(this._playerUsePropView);
         KeyboardManager.getInstance().isStopDispatching = false;
         _gameInfo.resetResultCard();
         _gameInfo.livings.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         _gameInfo.addEventListener(GameEvent.WIND_CHANGED,this.__windChanged);
         _gameInfo.addEventListener(GameEvent.BOMB_COMPLETE,this.__bombComplete);
         PlayerManager.Instance.Self.FightBag.addEventListener(BagEvent.UPDATE,this.__selfObtainItem);
         PlayerManager.Instance.Self.TempBag.addEventListener(BagEvent.UPDATE,this.__getTempItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_OVER,this.__gameOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT,this.__shoot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ALL_SHOOT,this.__allReadyShoot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE,this.__startMove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_BLOOD,this.__playerBlood);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_VANE,this.__changWind);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_HIDE,this.__playerHide);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_NONOLE,this.__playerNoNole);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_PROP,this.__playerUsingItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_DANDER,this.__dander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REDUCE_DANDER,this.__reduceDander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK,this.__changeShootCount);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SUICIDE,this.__suicide);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,this.__beginShoot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_BALL,this.__changeBall);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_FROST,this.__forstPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_MOVIE,this.__playMovie);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_CHAGEANGLE,this.__livingTurnRotation);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_SOUND,this.__playSound);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_LIVING,this.__addLiving);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_MOVETO,this.__livingMoveto);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_FALLING,this.__livingFalling);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_JUMP,this.__livingJump);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BEAT,this.__livingBeat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SAY,this.__livingSay);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING,this.__livingRangeAttacking);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED,this.__livingDirChanged);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT,this.__focusOnObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_STATE,this.__changeState);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BARRIER_INFO,this.__barrierInfoHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_MAP_THINGS,this.__addMapThing);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BOARD_STATE,this.__updatePhysicObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR,this.__removePhysicObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER,this.__addTipLayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FORBID_DRAG,this.__forbidDragFocus);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOP_LAYER,this.__topLayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTROL_BGM,this.__controlBGM);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE,this.__onLivingBoltmove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_TARGET,this.__onChangePlayerTarget);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SHOW_BLOOD,this.__livingShowBlood);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SHOW_NPC,this.__livingShowNpc);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTION_MAPPING,this.__livingActionMapping);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BUFF,this.__updateBuff);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_BUFF,this.__updatePetBuff);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAMESYSMESSAGE,this.__gameSysMessage);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_PROPERTY,this.__objectSetProperty);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_PET_SKILL,this.__usePetSkill);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHT_BOX_SKILL,this.__useFightKitSkillSocket);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DROP_GOODS,this.__onDropItemComplete);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_DIALOG,this.__getDialogFromServer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_END_FIRE,this.__playerEndFire);
         _selfMarkBar.addEventListener(GameEvent.SINGLE_TURN_NOTICE,this.__changePlayerInsingle);
         StatisticManager.Instance().startAction(StatisticManager.GAME,"yes");
         this._syncTimer = new Timer(10000);
         this._syncTimer.addEventListener(TimerEvent.TIMER,this.__syncLifeTime);
         this._syncTimer.start();
         this._tipItems = new Dictionary(true);
         CacheSysManager.lock(CacheConsts.ALERT_IN_FIGHT);
         PlayerManager.Instance.Self.isUpGradeInGame = false;
         BackgoundView.Instance.hide();
         this._hitsNumView = new HitsNumView();
         addChild(this._hitsNumView);
         GameManager.Instance.hitsNumView = this._hitsNumView;
         if(RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
         {
            ChatManager.Instance.input.faceEnabled = false;
         }
         GameManager.Instance.addEventListener(GameEvent.LOCK_SCREEN,this.__lockScreenHandler);
         this._gameOverTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__doGameOver);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         addEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
      }
      
      private function __syncLifeTime(param1:TimerEvent) : void
      {
         SocketManager.Instance.out.syncLifeTime();
      }
      
      private function __getDialogFromServer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         if(DialogManager.Instance.showing)
         {
            return;
         }
         _loc2_ = param1.pkg;
         GameManager.Instance.dialogId = _loc2_.readInt();
         GameManager.Instance.dropTaskGoodsNpcId = _loc2_.readInt();
         GameManager.Instance.dropTaskGoodsId = DialogManager.Instance.dropGoodsId(GameManager.Instance.dialogId);
         if(!DialogManager.Instance.hasDialogs(GameManager.Instance.dialogId))
         {
            GameManager.Instance.dialogId = -1;
         }
         if(GameManager.Instance.dropTaskGoodsId == -1)
         {
            this.showDialog(GameManager.Instance.dialogId);
         }
         else if(DialogManager.Instance.getDropPoint(GameManager.Instance.dialogId))
         {
            if(DialogManager.Instance.dropGoodsBeforeDialog(GameManager.Instance.dialogId))
            {
               this.dropGoods();
            }
            else
            {
               this.showDialog(GameManager.Instance.dialogId);
            }
         }
      }
      
      private function dropGoods() : void
      {
         var _loc2_:String = null;
         var _loc4_:Point = null;
         this.setMapFocusLock(true);
         var _loc1_:Point = DialogManager.Instance.getDropPoint(GameManager.Instance.dialogId);
         switch(GameManager.Instance.dropTaskGoodsId)
         {
            case GameManager.TASK_GOOD_LEAD:
               this._goodsMovie1 = ComponentFactory.Instance.creat("asset.trainer8.getLead");
               if(_gameInfo.selfGamePlayer.mouseState)
               {
                  _loc2_ = "trainer.explain.mouseMode.posGetLead";
               }
               else
               {
                  _loc2_ = "trainer.explain.posGetLead";
               }
               this._goodsMovie2 = ComponentFactory.Instance.creat("asset.trainer8.getNormal");
               this._goodsMovie2.x = _loc1_.x + 80;
               this._goodsMovie2.y = _loc1_.y;
               SoundManager.instance.play("203");
               LayerManager.Instance.addToLayer(this._goodsMovie2,LayerManager.GAME_UI_LAYER);
               if(_gameInfo.selfGamePlayer.mouseState)
               {
                  _loc4_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.mouseMode.posGetNormalMode");
               }
               else
               {
                  _loc4_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetNormalMode");
               }
               this._timeoutMark1 = setTimeout(this.tweenTaskGoods,4200,this._goodsMovie2,_loc4_);
               break;
            case GameManager.TASK_GOOD_PLANE:
               this._goodsMovie1 = ComponentFactory.Instance.creat("asset.trainer9.getPlane");
               if(_gameInfo.selfGamePlayer.mouseState)
               {
                  _loc2_ = "trainer.explain.mouseMode.posGetPlane";
               }
               else
               {
                  _loc2_ = "trainer.explain.posGetPlane";
               }
         }
         this._goodsMovie1.x = _loc1_.x;
         this._goodsMovie1.y = _loc1_.y;
         SoundManager.instance.play("203");
         LayerManager.Instance.addToLayer(this._goodsMovie1,LayerManager.GAME_UI_LAYER);
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject(_loc2_);
         this._timeoutMark2 = setTimeout(this.tweenTaskGoods,4200,this._goodsMovie1,_loc3_);
      }
      
      private function tweenTaskGoods(param1:MovieClip, param2:Point) : void
      {
         this._dropGoodsTween = null;
         SoundManager.instance.play("204");
         this._dropGoodsTween = TweenLite.to(param1,0.7,{
            "x":param2.x,
            "y":param2.y,
            "scaleX":0.5,
            "scaleY":0.5,
            "onComplete":this.__onFinishTween,
            "onCompleteParams":[param1]
         });
      }
      
      private function __onFinishTween(param1:MovieClip) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         if(param1)
         {
            if(param1.parent)
            {
               param1.parent.removeChild(param1);
            }
            param1 = null;
         }
         if(GameManager.Instance.dropTaskGoodsId == -1 || !(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON))
         {
            return;
         }
         switch(GameManager.Instance.dropTaskGoodsId)
         {
            case GameManager.TASK_GOOD_LEAD:
               this._iconWrapper1 = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer8.getLeadIcon"),true,true);
               if(_gameInfo.selfGamePlayer.mouseState)
               {
                  _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.mouseMode.posGetLeadIcon");
               }
               else
               {
                  _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetLeadIcon");
               }
               GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_LEAD_ICON));
               this._iconWrapper2 = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer8.getNormalIcon"),true,true);
               if(_gameInfo.selfGamePlayer.mouseState)
               {
                  _loc3_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.mouseMode.posGetNormalModeIcon");
               }
               else
               {
                  _loc3_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetNormalModeIcon");
               }
               GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_NORMAL_ICON));
               this._iconWrapper2.movie.x = _loc3_.x;
               this._iconWrapper2.movie.y = _loc3_.y;
               if(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
               {
                  SoundManager.instance.play("205");
                  LayerManager.Instance.addToLayer(this._iconWrapper2.movie,LayerManager.GAME_UI_LAYER,false);
               }
               break;
            case GameManager.TASK_GOOD_PLANE:
               this._iconWrapper1 = new MovieClipWrapper(ClassUtils.CreatInstance("asset.trainer9.getPlaneIcon"),true,true);
               if(_gameInfo.selfGamePlayer.mouseState)
               {
                  _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.mouseMode.posGetPlaneIcon");
               }
               else
               {
                  _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.explain.posGetPlaneIcon");
               }
               GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_PLANE_ICON));
         }
         this._iconWrapper1.movie.x = _loc2_.x;
         this._iconWrapper1.movie.y = _loc2_.y;
         if(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
         {
            SoundManager.instance.play("205");
            LayerManager.Instance.addToLayer(this._iconWrapper1.movie,LayerManager.GAME_UI_LAYER,false);
         }
         GameManager.Instance.dropTaskGoodsId = -1;
         GameManager.Instance.dropTaskGoodsNpcId = -1;
         this.setMapFocusLock(false);
         if(GameManager.Instance.dialogId > 0)
         {
            if(DialogManager.Instance.hasDialogs(GameManager.Instance.dialogId))
            {
               this._timeoutMark1 = setTimeout(this.showDialog,1000,GameManager.Instance.dialogId);
            }
         }
      }
      
      private function __dialogEndCallBack(param1:Event) : void
      {
         DialogManager.Instance.removeEventListener(Event.COMPLETE,this.__dialogEndCallBack);
         ChatManager.Instance.chatDisabled = false;
         GameManager.Instance.dialogId = -1;
         GameManager.Instance.dropTaskGoodsNpcId = -1;
         if(DialogManager.Instance.getDropPoint(GameManager.Instance.dialogId) && GameManager.Instance.dropTaskGoodsId >= 0)
         {
            this._timeoutMark1 = setTimeout(this.dropGoods,500);
         }
      }
      
      private function __lockScreenHandler(param1:GameEvent) : void
      {
         this.setMapFocusLock(param1.data);
      }
      
      private function setMapFocusLock(param1:Boolean) : void
      {
         map.smallMap.allowDrag = !param1;
      }
      
      private function showDialog(param1:int, param2:Function = null) : void
      {
         LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox,LayerManager.STAGE_TOP_LAYER);
         DialogManager.Instance.addEventListener(Event.COMPLETE,this.__dialogEndCallBack);
         DialogManager.Instance.showDialog(param1,2500,false,false,true,8);
      }
      
      private function __gameSysMessage(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:int = _loc2_.readInt();
         switch(_loc3_)
         {
            case GameSysMsgType.GET_ITEM_INVENTORY_FULL:
               MessageTipManager.getInstance().show(String(_loc5_),2);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:DisplayObject = null;
         this.numCh = 0;
         var _loc2_:int = 0;
         while(_loc2_ < stage.numChildren)
         {
            _loc3_ = StageReferance.stage.getChildAt(_loc2_);
            _loc3_.visible = true;
            ++this.numCh;
            if(_loc3_ is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(_loc3_));
            }
            _loc2_++;
         }
      }
      
      private function show(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            _loc3_.visible = true;
            ++this.numCh;
            if(_loc3_ is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(_loc3_));
            }
            _loc2_++;
         }
      }
      
      private function __windChanged(param1:GameEvent) : void
      {
         _map.wind = param1.data.wind;
         _vane.update(_map.wind,param1.data.isSelfTurn,param1.data.windNumArr);
      }
      
      override public function getType() : String
      {
         return StateType.MULTISHOOT_FIGHTING;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         var _loc2_:SimpleObject = null;
         super.dispose();
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.onClick);
         SoundManager.instance.stopMusic();
         PageInterfaceManager.restorePageTitle();
         if(PlayerManager.Instance.hasTempStyle)
         {
            PlayerManager.Instance.readAllTempStyleEvent();
         }
         this.clearBombs();
         ObjectUtils.disposeObject(this._damageStasticView);
         this._damageStasticView = null;
         ObjectUtils.disposeObject(this._playerUsePropView);
         this._playerUsePropView = null;
         _gameInfo.removeEventListener(GameEvent.WIND_CHANGED,this.__windChanged);
         _gameInfo.livings.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         _gameInfo.removeEventListener(GameEvent.BOMB_COMPLETE,this.__bombComplete);
         _gameInfo.removeAllMonsters();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT,this.__shoot);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ALL_SHOOT,this.__allReadyShoot);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE,this.__startMove);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_BLOOD,this.__playerBlood);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_VANE,this.__changWind);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_HIDE,this.__playerHide);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_NONOLE,this.__playerNoNole);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_PROPERTY,this.__objectSetProperty);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_PROP,this.__playerUsingItem);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_DANDER,this.__dander);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REDUCE_DANDER,this.__reduceDander);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK,this.__changeShootCount);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SUICIDE,this.__suicide);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,this.__beginShoot);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_BALL,this.__changeBall);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_FROST,this.__forstPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,this.__missionOver);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_OVER,this.__gameOver);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_MOVIE,this.__playMovie);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_CHAGEANGLE,this.__livingTurnRotation);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_SOUND,this.__playSound);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_LIVING,this.__addLiving);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_MOVETO,this.__livingMoveto);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_FALLING,this.__livingFalling);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_JUMP,this.__livingJump);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BEAT,this.__livingBeat);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_SAY,this.__livingSay);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING,this.__livingRangeAttacking);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED,this.__livingDirChanged);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT,this.__focusOnObject);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_STATE,this.__changeState);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BARRIER_INFO,this.__barrierInfoHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_MAP_THINGS,this.__addMapThing);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_BOARD_STATE,this.__updatePhysicObject);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR,this.__removePhysicObject);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER,this.__addTipLayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FORBID_DRAG,this.__forbidDragFocus);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOP_LAYER,this.__topLayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTROL_BGM,this.__controlBGM);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE,this.__onLivingBoltmove);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_SHOW_BLOOD,this.__livingShowBlood);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_SHOW_NPC,this.__livingShowNpc);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_TARGET,this.__onChangePlayerTarget);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ACTION_MAPPING,this.__livingActionMapping);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_BUFF,this.__updateBuff);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_BUFF,this.__updatePetBuff);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAMESYSMESSAGE,this.__gameSysMessage);
         PlayerManager.Instance.Self.FightBag.removeEventListener(BagEvent.UPDATE,this.__selfObtainItem);
         PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE,this.__getTempItem);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_PET_SKILL,this.__usePetSkill);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHT_BOX_SKILL,this.__useFightKitSkillSocket);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DROP_GOODS,this.__onDropItemComplete);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SHOW_DIALOG,this.__getDialogFromServer);
         if(_selfMarkBar)
         {
            _selfMarkBar.removeEventListener(GameEvent.SINGLE_TURN_NOTICE,this.__changePlayerInsingle);
         }
         GameManager.Instance.removeEventListener(GameEvent.LOCK_SCREEN,this.__lockScreenHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_END_FIRE,this.__playerEndFire);
         this._gameOverTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__doGameOver);
         this._syncTimer.stop();
         this._syncTimer.removeEventListener(TimerEvent.TIMER,this.__syncLifeTime);
         this._syncTimer = null;
         GameManager.Instance.clearDropData();
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
         if(this._turnMovie)
         {
            this._turnMovie.dispose();
         }
         if(this._dropGoodsTween)
         {
            this._dropGoodsTween.kill();
            this._dropGoodsTween = null;
         }
         if(this._timeoutMark1)
         {
            clearTimeout(this._timeoutMark1);
         }
         if(this._timeoutMark2)
         {
            clearTimeout(this._timeoutMark2);
         }
         if(this._goodsMovie1)
         {
            if(this._goodsMovie1.parent)
            {
               this._goodsMovie1.parent.removeChild(this._goodsMovie1);
            }
            this._goodsMovie1 = null;
         }
         if(this._goodsMovie2)
         {
            if(this._goodsMovie2.parent)
            {
               this._goodsMovie2.parent.removeChild(this._goodsMovie2);
            }
            this._goodsMovie2 = null;
         }
         if(this._iconWrapper1)
         {
            if(this._iconWrapper1.movie)
            {
               if(this._iconWrapper1.movie.parent)
               {
                  this._iconWrapper1.movie.parent.removeChild(this._iconWrapper1.movie);
               }
            }
         }
         this._iconWrapper1 = null;
         if(this._iconWrapper2)
         {
            if(this._iconWrapper2.movie)
            {
               if(this._iconWrapper2.movie.parent)
               {
                  this._iconWrapper2.movie.parent.removeChild(this._iconWrapper2.movie);
               }
            }
         }
         this._iconWrapper2 = null;
         for each(_loc2_ in this._tipItems)
         {
            delete this._tipLayers[_loc2_.Id];
            _loc2_.dispose();
            _loc2_ = null;
         }
         this._tipItems = null;
         if(this._tipLayers)
         {
            if(this._tipLayers.parent)
            {
               this._tipLayers.parent.removeChild(this._tipLayers);
            }
         }
         this._tipLayers = null;
         _gameInfo.resetBossCardCnt();
         if(this._expView)
         {
            this._expView.removeEventListener(GameEvent.EXPSHOWED,this.__expShowed);
         }
         if(this._settlement)
         {
            ObjectUtils.disposeObject(this._settlement);
            this._settlement = null;
         }
         ObjectUtils.disposeObject(this._settlementPVP);
         this._settlementPVP = null;
         ObjectUtils.disposeObject(this._settlementFightRobot);
         this._settlementFightRobot = null;
         super.leaving(param1);
         if(StateManager.isExitRoom(param1.getType()))
         {
            GameManager.Instance.reset();
            if(param1.getType() != StateType.ARENA)
            {
               RoomManager.Instance.reset();
            }
         }
         else if(StateManager.isExitGame(param1.getType()) && GameManager.Instance.Current.roomType != RoomInfo.SINGLE_DUNGEON)
         {
            GameManager.Instance.reset();
         }
         BallManager.clearAsset();
         BackgoundView.Instance.show();
         GameManager.Instance.hitsNumView = null;
         ObjectUtils.disposeObject(this._hitsNumView);
         this._hitsNumView = null;
      }
      
      override public function addedToStage() : void
      {
         super.addedToStage();
         stage.focus = _map;
      }
      
      override protected function addChatView() : void
      {
         ChatManager.Instance.state = ChatManager.CHAT_MULTI_SHOOT_GAME_STATE;
         addChild(ChatManager.Instance.view);
      }
      
      override public function getBackType() : String
      {
         if(_gameInfo.roomType == RoomInfo.CHALLENGE_ROOM)
         {
            return StateType.CHALLENGE_ROOM;
         }
         if(_gameInfo.roomType == RoomInfo.MATCH_ROOM || _gameInfo.roomType == RoomInfo.SINGLE_ROOM)
         {
            return StateType.MATCH_ROOM;
         }
         if(_gameInfo.roomType == RoomInfo.FRESHMAN_ROOM)
         {
            if(StartupResourceLoader.firstEnterHall)
            {
               return StateType.FRESHMAN_ROOM2;
            }
            return StateType.FRESHMAN_ROOM1;
         }
         if(_gameInfo.roomType == RoomInfo.HIJACK_CAR)
         {
            return StateType.MAIN;
         }
         return StateType.DUNGEON_ROOM;
      }
      
      override public function setCurrentPlayer(param1:Living) : void
      {
         if(!GameManager.Instance.Current.selfGamePlayer.isLiving && _selfBuffBar)
         {
            _selfBuffBar.visible = false;
         }
         else if(_selfBuffBar)
         {
            _selfBuffBar.visible = true;
         }
         if(!RoomManager.Instance.current.selfRoomPlayer.isViewer && param1 && _selfBuffBar)
         {
            _selfBuffBar.drawBuff(param1);
         }
         if(_leftPlayerView)
         {
            _leftPlayerView.info = param1;
         }
         _map.bringToFront(param1);
         if(_map.currentPlayer && !(param1 is TurnedLiving))
         {
            _map.currentPlayer.isAttacking = false;
            _map.currentPlayer = null;
         }
         else
         {
            _map.currentPlayer = param1 as TurnedLiving;
         }
         updatePlayerState(param1);
         if(_leftPlayerView)
         {
            addChildAt(_leftPlayerView,this.numChildren - 3);
         }
         var _loc2_:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
         if(_loc2_)
         {
            _loc2_.soulPropEnabled = !_loc2_.isLiving && _gameInfo.currentLiving.team == _loc2_.team;
         }
      }
      
      protected function __playerChange(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:Living = null;
         var _loc5_:Living = null;
         var _loc6_:GameLiving = null;
         var _loc7_:GameLiving = null;
         PageInterfaceManager.restorePageTitle();
         this.clearRemovePlayer();
         this.clearBombs(true);
         this._damageStasticView.start();
         if(this._playerUsePropView)
         {
            this._playerUsePropView.hide();
         }
         this._playerUsePropView = ComponentFactory.Instance.creat("game.view.prop.PlayerUsePropView",[_gameInfo.teams[param1.pkg.extend1]]);
         addChild(this._playerUsePropView);
         _gameInfo.clearStasticInfo();
         GameManager.Instance.resetHitsNum();
         if(_gameInfo.gameMode == GameModeType.SINGLE_DUNGOEN)
         {
            _selfMarkBar.shutdownInSingle();
         }
         else
         {
            _selfMarkBar.shutdown();
         }
         _map.currentFocusedLiving = null;
         var _loc2_:int = param1.pkg.extend1;
         if(param1.pkg.extend1 == _gameInfo.self.team)
         {
            _loc3_ = _gameInfo.currentLiving = _gameInfo.self;
         }
         else if(_gameInfo.teams[_loc2_].list.length > 0 && _gameInfo.teams[_loc2_].list[0].isPlayer())
         {
            _loc3_ = _gameInfo.currentLiving = _gameInfo.teams[_loc2_].list[0];
         }
         else
         {
            _loc3_ = _gameInfo.currentLiving = _gameInfo.findLiving(param1.pkg.extend2);
         }
         if(_loc3_ is TurnedLiving)
         {
            this._ignoreSmallEnemy = false;
            if(!_loc3_.isLiving)
            {
               this.setCurrentPlayer(null);
            }
            if(_loc3_.playerInfo == PlayerManager.Instance.Self)
            {
               PageInterfaceManager.changePageTitle("");
               if(SavePointManager.Instance.isInSavePoint(19))
               {
                  GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.GET_PLANE_ICON));
               }
            }
            param1.executed = false;
            this._soundPlayFlag = true;
            _map.act(new MultiChangePlayerAction(_map,_loc3_ as TurnedLiving,param1,param1.pkg));
         }
         else
         {
            _map.act(new ChangeNpcAction(this,_map,_loc3_ as Living,param1,param1.pkg,this._ignoreSmallEnemy));
            if(!this._ignoreSmallEnemy)
            {
               this._ignoreSmallEnemy = true;
            }
         }
         if(_loc3_ && _loc3_.playerInfo == PlayerManager.Instance.Self)
         {
            if(_gameInfo.selfGamePlayer.mouseState)
            {
               ChatManager.Instance.view.currentType = false;
            }
         }
         else if(_gameInfo.selfGamePlayer.mouseState)
         {
            ChatManager.Instance.view.currentType = true;
         }
         var _loc4_:DictionaryData = GameManager.Instance.Current.livings;
         for each(_loc5_ in _loc4_)
         {
            _loc7_ = this.getGameLivingByID(_loc5_.LivingID) as GameLiving;
            if(_loc7_)
            {
               _loc7_.fightPowerVisible = false;
            }
            _loc5_.isReady = false;
         }
         for each(_loc6_ in _players)
         {
            if(_loc6_ is GamePlayer && GamePlayer(_loc6_).gamePet)
            {
               GamePlayer(_loc6_).gamePet.endShow();
            }
         }
         PrepareShootAction.hasDoSkillAnimation = false;
         GameManager.Instance.isRed = true;
      }
      
      private function __changePlayerInsingle(param1:GameEvent) : void
      {
         SoundManager.instance.play("016");
         if(!this._turnMovie || !this._turnMovie.movie)
         {
            if(this._turnMovie)
            {
               ObjectUtils.disposeObject(this._turnMovie);
               this._turnMovie = null;
            }
            this._turnMovie = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.TurnAsset2")),true,false,true);
            this._turnMovie.movie.mouseChildren = this._turnMovie.movie.mouseEnabled = false;
            this._turnMovie.movie.x = 440;
            this._turnMovie.movie.y = 180;
            _map.gameView.addChild(this._turnMovie.movie);
         }
         this._turnMovie.gotoAndPlay(1);
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         _selfMarkBar.setTick(0);
         if(this._turnMovie)
         {
            this._turnMovie.stop();
            this._turnMovie.dispose();
            this._turnMovie = null;
         }
      }
      
      private function __mouseDown(param1:MouseEvent) : void
      {
         this.__keyDown(null);
      }
      
      private function __playMovie(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc3_ = param1.pkg.readUTF();
            _loc2_.playMovie(_loc3_);
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __livingTurnRotation(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc3_ = param1.pkg.readInt() / 10;
            _loc4_ = param1.pkg.readInt() / 10;
            _loc5_ = param1.pkg.readUTF();
            _loc2_.turnRotation(_loc3_,_loc4_,_loc5_);
            _map.bringToFront(_loc2_);
         }
      }
      
      protected function __addLiving(param1:CrazyTankSocketEvent) : void
      {
         var _loc16_:Living = null;
         var _loc17_:GameLiving = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:String = _loc2_.readUTF();
         var _loc6_:String = _loc2_.readUTF();
         var _loc7_:String = _loc2_.readUTF();
         var _loc8_:Point = new Point(_loc2_.readInt(),_loc2_.readInt());
         var _loc9_:int = _loc2_.readInt();
         var _loc10_:int = _loc2_.readInt();
         var _loc11_:int = _loc2_.readInt();
         var _loc12_:int = _loc2_.readByte();
         var _loc13_:int = _loc2_.readByte();
         var _loc14_:int = _loc2_.readInt();
         var _loc15_:Boolean = _loc13_ == 0 ? Boolean(true) : Boolean(false);
         if(_map.getPhysical(_loc4_))
         {
            _map.getPhysical(_loc4_).dispose();
         }
         if(_loc3_ != 4 && _loc3_ != 5 && _loc3_ != 6 && _loc3_ != 12)
         {
            _loc16_ = new SmallEnemy(_loc4_,_loc11_,_loc10_);
            _loc16_.typeLiving = _loc3_;
            _loc16_.actionMovieName = _loc6_;
            _loc16_.direction = _loc12_;
            _loc16_.pos = _loc8_;
            _loc16_.name = _loc5_;
            _loc16_.isBottom = _loc15_;
            _loc16_.explainType(_loc14_);
            _loc16_.isShowReadyMC = true;
            _gameInfo.addGamePlayer(_loc16_);
            _loc17_ = new GameSmallEnemy(_loc16_ as SmallEnemy);
            if(_loc9_ != _loc16_.maxBlood)
            {
               _loc16_.initBlood(_loc9_);
            }
         }
         else
         {
            _loc16_ = new SimpleBoss(_loc4_,_loc11_,_loc10_);
            _loc16_.typeLiving = _loc3_;
            _loc16_.actionMovieName = _loc6_;
            _loc16_.direction = _loc12_;
            _loc16_.pos = _loc8_;
            _loc16_.name = _loc5_;
            _loc16_.isBottom = _loc15_;
            _loc16_.explainType(_loc14_);
            _loc16_.isShowReadyMC = true;
            _gameInfo.addGamePlayer(_loc16_);
            _loc17_ = new GameSimpleBoss(_loc16_ as SimpleBoss);
            if(_loc9_ != _loc16_.maxBlood)
            {
               _loc16_.initBlood(_loc9_);
            }
         }
         _loc17_.name = _loc5_;
         _map.addPhysical(_loc17_);
         if(_loc7_.length > 0)
         {
            _loc17_.doAction(_loc7_);
         }
         else
         {
            _loc17_.doAction(Living.BORN_ACTION);
         }
         _playerThumbnailLController.addLiving(_loc17_);
         addChild(_playerThumbnailLController);
         if(_loc16_ is SimpleBoss)
         {
            _map.setCenter(_loc17_.x,_loc17_.y - 150,false,AnimationLevel.MIDDLE,AnimationSet.PUBLIC_OWNER);
         }
         else
         {
            _map.setCenter(_loc17_.x,_loc17_.y - 150,true,AnimationLevel.MIDDLE,AnimationSet.PUBLIC_OWNER);
         }
      }
      
      private function __addTipLayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc10_:MovieClip = null;
         var _loc11_:Class = null;
         var _loc12_:MovieClipWrapper = null;
         var _loc13_:SimpleObject = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = param1.pkg.readInt();
         var _loc6_:String = param1.pkg.readUTF();
         var _loc7_:String = param1.pkg.readUTF();
         var _loc8_:int = param1.pkg.readInt();
         var _loc9_:int = param1.pkg.readInt();
         if(_loc3_ == 10)
         {
            if(ModuleLoader.hasDefinition(_loc6_))
            {
               _loc11_ = ModuleLoader.getDefinition(_loc6_) as Class;
               _loc10_ = new _loc11_() as MovieClip;
               _loc12_ = new MovieClipWrapper(_loc10_,false,true);
               this.addTipSprite(_loc12_.movie);
               _loc12_.gotoAndPlay(1);
            }
         }
         else
         {
            if(this._tipItems[_loc2_])
            {
               _loc13_ = this._tipItems[_loc2_] as SimpleObject;
            }
            else
            {
               _loc13_ = new SimpleObject(_loc2_,_loc3_,_loc6_,_loc7_);
               this.addTipSprite(_loc13_);
            }
            _loc13_.playAction(_loc7_);
            this._tipItems[_loc2_] = _loc13_;
         }
      }
      
      private function addTipSprite(param1:Sprite) : void
      {
         if(!this._tipLayers)
         {
            this._tipLayers = new Sprite();
            this._tipLayers.mouseChildren = this._tipLayers.mouseEnabled = false;
            addChild(this._tipLayers);
         }
         this._tipLayers.addChild(param1);
      }
      
      private function __addMapThing(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = param1.pkg.readInt();
         var _loc6_:String = param1.pkg.readUTF();
         var _loc7_:String = param1.pkg.readUTF();
         var _loc8_:int = param1.pkg.readInt();
         var _loc9_:int = param1.pkg.readInt();
         var _loc10_:int = param1.pkg.readInt();
         var _loc11_:int = param1.pkg.readInt();
         var _loc12_:int = param1.pkg.readInt();
         var _loc13_:SimpleObject = null;
         switch(_loc3_)
         {
            case 1:
               _loc13_ = new SimpleBox(_loc2_,_loc6_);
               break;
            case 2:
               _loc13_ = new SimpleObject(_loc2_,1,_loc6_,_loc7_);
               break;
            default:
               _loc13_ = new SimpleObject(_loc2_,0,_loc6_,_loc7_,_loc11_ == 6);
         }
         _loc13_.x = _loc4_;
         _loc13_.y = _loc5_;
         _loc13_.scaleX = _loc8_;
         _loc13_.scaleY = _loc9_;
         _loc13_.rotation = _loc10_;
         if(_loc3_ == 1)
         {
            this.addBox(_loc13_);
         }
         this.addEffect(_loc13_,_loc12_,_loc11_);
      }
      
      private function addBox(param1:SimpleObject) : void
      {
         if(GameManager.Instance.Current.selfGamePlayer.isLiving)
         {
            if(!this._boxArr)
            {
               this._boxArr = new Array();
            }
            this._boxArr.push(param1);
         }
         else
         {
            this.addEffect(param1);
         }
      }
      
      private function addEffect(param1:SimpleObject, param2:int = 0, param3:int = 0) : void
      {
         switch(param2)
         {
            case -1:
               this.addStageCurtain(param1);
               break;
            case 0:
               _map.addPhysical(param1);
               if(param3 > 0 && param3 != 6)
               {
                  _map.phyBringToFront(param1);
               }
               break;
            default:
               _map.addObject(param1);
               this.getGameLivingByID(param2 - 1).addChild(param1);
         }
      }
      
      private function __updatePhysicObject(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:SimpleObject = _map.getPhysical(_loc2_) as SimpleObject;
         if(!_loc3_)
         {
            _loc3_ = this._tipItems[_loc2_] as SimpleObject;
         }
         var _loc4_:String = param1.pkg.readUTF();
         if(_loc3_)
         {
            _loc3_.playAction(_loc4_);
         }
         var _loc5_:PhyobjEvent = new PhyobjEvent(_loc4_);
         dispatchEvent(_loc5_);
      }
      
      private function __applySkill(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         SkillManager.applySkillToLiving(_loc3_,_loc4_,_loc2_);
      }
      
      private function __removeSkill(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         SkillManager.removeSkillFromLiving(_loc3_,_loc4_,_loc2_);
      }
      
      private function __removePhysicObject(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:PhysicalObj = this.getGameLivingByID(_loc2_);
         var _loc4_:Boolean = true;
         if(_loc3_ && _loc3_.parent)
         {
            _map.removePhysical(_loc3_);
         }
         if(_loc3_ && _loc3_.parent)
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         if(_loc4_ && _loc3_)
         {
            if(!(_loc3_ is GameLiving) || GameLiving(_loc3_).isExist)
            {
               _loc3_.dispose();
            }
         }
      }
      
      private function __focusOnObject(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Array = [];
         var _loc4_:Object = new Object();
         _loc4_.x = param1.pkg.readInt();
         _loc4_.y = param1.pkg.readInt();
         _loc3_.push(_loc4_);
         _map.act(new ViewEachObjectAction(_map,_loc3_,_loc2_));
      }
      
      private function __barrierInfoHandler(param1:CrazyTankSocketEvent) : void
      {
         barrierInfo = param1;
      }
      
      private function __livingMoveto(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc3_ = new Point(param1.pkg.readInt(),param1.pkg.readInt());
            _loc4_ = new Point(param1.pkg.readInt(),param1.pkg.readInt());
            _loc5_ = param1.pkg.readInt();
            _loc6_ = param1.pkg.readUTF();
            _loc7_ = param1.pkg.readUTF();
            _loc2_.pos = _loc3_;
            _loc2_.moveTo(0,_loc4_,0,true,_loc6_,_loc5_,_loc7_);
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __livingFalling(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         var _loc3_:Point = new Point(param1.pkg.readInt(),param1.pkg.readInt());
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         var _loc6_:int = param1.pkg.readInt();
         if(_loc2_)
         {
            _loc2_.fallTo(_loc3_,_loc4_,_loc5_,_loc6_);
            if(_loc3_.y - _loc2_.pos.y > 50)
            {
               _map.setCenter(_loc3_.x,_loc3_.y - 150,false,AnimationLevel.MIDDLE,_loc2_.LivingID);
            }
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __livingJump(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         var _loc3_:Point = new Point(param1.pkg.readInt(),param1.pkg.readInt());
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         var _loc6_:int = param1.pkg.readInt();
         _loc2_.jumpTo(_loc3_,_loc4_,_loc5_,_loc6_);
         _map.bringToFront(_loc2_);
      }
      
      private function __livingBeat(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:Living = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Living = _gameInfo.findLiving(_loc2_.extend1);
         var _loc4_:String = _loc2_.readUTF();
         var _loc5_:uint = _loc2_.readInt();
         var _loc6_:Array = new Array();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc5_)
         {
            _loc8_ = _gameInfo.findLiving(_loc2_.readInt());
            _loc9_ = _loc2_.readInt();
            _loc10_ = _loc2_.readInt();
            _loc11_ = _loc2_.readInt();
            _loc12_ = _loc2_.readInt();
            _loc13_ = new Object();
            _loc13_["action"] = _loc4_;
            _loc13_["target"] = _loc8_;
            _loc13_["damage"] = _loc9_;
            _loc13_["targetBlood"] = _loc10_;
            _loc13_["dander"] = _loc11_;
            _loc13_["attackEffect"] = _loc12_;
            _loc6_.push(_loc13_);
            if(_loc8_ && _loc8_.isPlayer() && _loc8_.isLiving)
            {
               (_loc8_ as Player).dander = _loc11_;
            }
            _loc7_++;
         }
         if(_loc3_)
         {
            _loc3_.beat(_loc6_);
         }
      }
      
      private function __livingSay(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(!_loc2_ || !_loc2_.isLiving)
         {
            return;
         }
         var _loc3_:String = param1.pkg.readUTF();
         var _loc4_:int = param1.pkg.readInt();
         _map.bringToFront(_loc2_);
         _loc2_.say(_loc3_,_loc4_);
      }
      
      private function __livingRangeAttacking(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Living = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.pkg.readInt();
            _loc5_ = param1.pkg.readInt();
            _loc6_ = param1.pkg.readInt();
            _loc7_ = param1.pkg.readInt();
            _loc8_ = param1.pkg.readInt();
            _loc9_ = _gameInfo.findLiving(_loc4_);
            if(_loc9_)
            {
               _loc9_.isHidden = false;
               _loc9_.isFrozen = false;
               _loc9_.updateBlood(_loc6_,_loc8_);
               _loc9_.showAttackEffect(1);
               _map.bringToFront(_loc9_);
               if(_loc9_.isSelf)
               {
                  _map.setCenter(_loc9_.pos.x,_loc9_.pos.y,false,AnimationLevel.MIDDLE,_loc4_);
               }
               if(_loc9_.isPlayer() && _loc9_.isLiving)
               {
                  (_loc9_ as Player).dander = _loc7_;
               }
            }
            _loc3_++;
         }
      }
      
      private function __livingDirChanged(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc3_ = param1.pkg.readInt();
            _loc2_.direction = _loc3_;
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __removePlayer(param1:DictionaryEvent) : void
      {
         this._msg = RoomManager.Instance._removeRoomMsg;
         var _loc2_:Player = param1.data as Player;
         this._playerRemoveList.add(_loc2_.LivingID,_loc2_);
      }
      
      private function __beginShoot(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:GamePlayer = null;
         if(_map.currentPlayer && _map.currentPlayer.isPlayer() && _map.currentPlayer.isLiving && param1.pkg.clientId != _map.currentPlayer.playerInfo.ID)
         {
            _map.executeAtOnce();
            _map.setCenter(_map.currentPlayer.pos.x,_map.currentPlayer.pos.y - 150,false,AnimationLevel.MIDDLE,param1.pkg.extend1);
            if(_players[_map.currentPlayer] as GamePlayer)
            {
               _loc2_ = _players[_map.currentPlayer];
               if(_loc2_.gamePet)
               {
                  _loc2_.gamePet.prepareForShow();
               }
            }
         }
      }
      
      protected function __shoot(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Number = NaN;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         var _loc14_:Rectangle = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:String = null;
         var _loc20_:Bomb = null;
         var _loc21_:int = 0;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:BombAction = null;
         var _loc29_:int = 0;
         var _loc30_:Living = null;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:Object = null;
         var _loc35_:Point = null;
         var _loc36_:Dictionary = null;
         var _loc37_:Bomb = null;
         var _loc38_:GameTurnedLiving = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc3_)
         {
            _loc4_ = _loc2_.readInt() / 10;
            _loc5_ = _loc2_.readBoolean();
            _loc6_ = _loc2_.readByte();
            _loc7_ = _loc2_.readByte();
            _loc8_ = _loc2_.readByte();
            _loc9_ = [_loc5_,_loc6_,_loc7_,_loc8_];
            GameManager.Instance.Current.setWind(_loc4_,_loc3_.isSelf,_loc9_);
            _loc10_ = new Array();
            _loc11_ = _loc2_.readInt();
            _loc12_ = 0;
            while(_loc12_ < _loc11_)
            {
               _loc20_ = new Bomb();
               _loc20_.number = _loc2_.readInt();
               _loc20_.shootCount = _loc2_.readInt();
               _loc20_.IsHole = _loc2_.readBoolean();
               _loc20_.Id = _loc2_.readInt();
               _loc20_.X = _loc2_.readInt();
               _loc20_.Y = _loc2_.readInt();
               _loc20_.VX = _loc2_.readInt();
               _loc20_.VY = _loc2_.readInt();
               _loc21_ = _loc2_.readInt();
               _loc20_.Template = BallManager.findBall(_loc21_);
               _loc20_.Actions = new Array();
               _loc20_.changedPartical = _loc2_.readUTF();
               _loc22_ = _loc2_.readInt() / 1000;
               _loc23_ = _loc2_.readInt() / 1000;
               _loc24_ = _loc22_ * _loc23_;
               _loc20_.damageMod = _loc24_;
               _loc20_.livingID = _loc3_.LivingID;
               _loc20_.isSelf = _loc3_.isSelf;
               _loc25_ = _loc2_.readInt();
               _loc27_ = 0;
               while(_loc27_ < _loc25_)
               {
                  _loc26_ = _loc2_.readInt();
                  _loc28_ = new BombAction(_loc26_,_loc2_.readInt(),_loc2_.readInt(),_loc2_.readInt(),_loc2_.readInt(),_loc2_.readInt(),_loc2_.readInt());
                  _loc20_.Actions.push(_loc28_);
                  if(_loc28_.type == ActionType.KILL_PLAYER)
                  {
                     if(_loc3_.isSelf)
                     {
                        if(!_gameInfo.stasticDamageList[_loc28_.param1])
                        {
                           _gameInfo.stasticDamageList.add(_loc28_.param1,0);
                        }
                        _gameInfo.stasticDamageList[_loc28_.param1] += _loc28_.param2;
                     }
                     else if(_loc28_.param1 == _gameInfo.self.LivingID)
                     {
                        if(!_gameInfo.stasticHurtList[_loc3_.LivingID])
                        {
                           _gameInfo.stasticHurtList.add(_loc3_.LivingID,0);
                        }
                        _gameInfo.stasticHurtList[_loc3_.LivingID] += _loc28_.param2;
                     }
                  }
                  if(_loc3_.isSelf && _loc28_.type == 2 && _loc28_.param4 > 0)
                  {
                     GameManager.Instance.hitsNum += _loc28_.param4;
                  }
                  _loc27_++;
               }
               if(_loc20_.shootCount == 1)
               {
                  GameManager.Instance.Current.selfGamePlayer.allBombCount = _loc11_;
               }
               _loc10_.push(_loc20_);
               _loc12_++;
            }
            _loc13_ = _loc2_.readInt();
            _loc15_ = [];
            _loc16_ = 0;
            while(_loc16_ < _loc13_)
            {
               _loc29_ = _loc2_.readInt();
               _loc30_ = _gameInfo.findLiving(_loc29_);
               _loc31_ = _loc2_.readInt();
               _loc32_ = _loc2_.readInt();
               _loc33_ = _loc2_.readInt();
               _loc34_ = {
                  "target":_loc30_,
                  "hp":_loc32_,
                  "damage":_loc31_,
                  "dander":_loc33_
               };
               _loc15_.push(_loc34_);
               if(_loc3_.isSelf)
               {
                  if(!_gameInfo.stasticDamageList[_loc29_])
                  {
                     _gameInfo.stasticDamageList.add(_loc29_,0);
                  }
                  _gameInfo.stasticDamageList[_loc29_] -= _loc31_;
               }
               else if(_loc29_ == _gameInfo.self.LivingID)
               {
                  if(!_gameInfo.stasticHurtList[_loc3_.LivingID])
                  {
                     _gameInfo.stasticHurtList.add(_loc3_.LivingID,0);
                  }
                  _gameInfo.stasticHurtList[_loc3_.LivingID] -= _loc31_;
               }
               if(!_loc14_)
               {
                  _loc14_ = new Rectangle(_loc30_.pos.x,_loc30_.pos.y);
               }
               if(_loc30_.pos.x < _loc14_.left)
               {
                  _loc14_.left = _loc30_.pos.x;
               }
               else if(_loc30_.pos.x > _loc14_.right)
               {
                  _loc14_.right = _loc30_.pos.x;
               }
               if(_loc30_.pos.y < _loc14_.top)
               {
                  _loc14_.top = _loc30_.pos.y;
               }
               else if(_loc30_.pos.x > _loc14_.bottom)
               {
                  _loc14_.bottom = _loc30_.pos.y;
               }
               _loc16_++;
            }
            _loc17_ = _loc2_.readInt();
            _loc18_ = _loc2_.readInt();
            _loc19_ = "attack" + _loc17_.toString();
            if(_loc17_ != 0 && Player(_loc3_).currentPet)
            {
               _loc35_ = null;
               if(_loc13_ <= 0)
               {
                  if(_loc10_.length == 3)
                  {
                     _loc35_ = Bomb(_loc10_[1]).target;
                  }
                  else if(_loc10_.length == 1)
                  {
                     _loc35_ = Bomb(_loc10_[0]).target;
                  }
               }
               else
               {
                  _loc35_ = new Point((_loc14_.left + _loc14_.right) / 2,(_loc14_.top + _loc14_.bottom) / 2);
               }
               _loc36_ = Player(_loc3_).currentPet.petBeatInfo;
               _loc36_["actionName"] = _loc19_;
               _loc36_["targetPoint"] = _loc35_;
               _loc36_["targets"] = _loc15_;
               _loc37_ = Bomb(_loc10_[_loc10_.length == 3 ? 1 : 0]);
               _loc37_.Actions.push(new BombAction(0,ActionType.PET,param1.pkg.extend1,0,0,0,_loc18_));
            }
            if(_loc3_.isPlayer())
            {
               _loc3_.isReady = true;
               (_loc3_ as Player).currentBomb = _loc10_[0].Template.ID;
               if(_gameInfo.getTeamLiveCount(_loc3_.team) > 1)
               {
                  this.mInfoDic.add(_loc3_.LivingID,_loc3_);
                  if(!this.mBombListDic[_loc3_.LivingID])
                  {
                     this.mBombListDic.add(_loc3_.LivingID,new Array());
                  }
                  this.mBombListDic[_loc3_.LivingID].push(_loc10_);
                  if(!this.mShootEventDic[_loc3_.LivingID])
                  {
                     this.mShootEventDic.add(_loc3_.LivingID,new Array());
                  }
                  this.mShootEventDic[_loc3_.LivingID].push(param1);
                  if(!_loc3_.isShoot)
                  {
                     _loc3_.isShoot = true;
                  }
               }
               else
               {
                  _loc38_ = this.getGameLivingByID(_loc3_.LivingID) as GameTurnedLiving;
                  if(!_loc3_.isBoss && !_loc3_.isShoot)
                  {
                     _map.act(new MultiPrepareShootAction(Vector.<GamePlayer>([_loc38_])));
                     _map.act(new MultiPlaySpellSkillAction(map,Vector.<GamePlayer>([_loc38_ as GamePlayer])));
                     _loc3_.isShoot = true;
                  }
                  _map.act(new MultiShootAction(Vector.<ShootBombAction>([new ShootBombAction(_loc38_,_loc10_,param1,_loc38_["point"].y)]),_map,_gameInfo));
               }
            }
            else
            {
               _loc3_.shoot(_loc10_,param1);
            }
         }
      }
      
      private function __allReadyShoot(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Living = null;
         var _loc7_:int = 0;
         var _loc9_:Dictionary = null;
         var _loc10_:* = null;
         var _loc12_:DamageObject = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Player = null;
         var _loc2_:int = param1.pkg.readInt();
         _map.lockOwner = -1;
         _loc7_ = 0;
         while(_loc7_ < _loc2_)
         {
            _loc3_ = param1.pkg.readInt();
            if(!this._damageTypeDic[_loc3_])
            {
               this._damageTypeDic[_loc3_] = new DictionaryData();
            }
            _loc13_ = param1.pkg.readInt();
            _loc14_ = 0;
            while(_loc14_ < _loc13_)
            {
               _loc5_ = param1.pkg.readInt();
               _loc4_ = param1.pkg.readInt();
               this._damageTypeDic[_loc3_][_loc4_] = GameInfo.DAMAGE_TYPE_LIST[_loc5_];
               _loc14_++;
            }
            if(_gameInfo.stasticHurtList[_loc4_] && _loc3_ == _gameInfo.selfGamePlayer.LivingID)
            {
               _map.lockOwner = _loc4_;
            }
            _loc7_++;
         }
         this.hideScreen();
         if(this.mInfoDic[_gameInfo.self.LivingID])
         {
            _map.lockOwner = _gameInfo.self.LivingID;
         }
         else if(_map.lockOwner == -1)
         {
            _loc15_ = _gameInfo.getNearestPlayer(this.mInfoDic);
            if(_loc15_)
            {
               _map.lockOwner = _loc15_.LivingID;
            }
         }
         var _loc8_:GameLiving = _map.getPhysical(_map.lockOwner) as GameLiving;
         if(_loc8_)
         {
            _loc8_.needFocus(0,0,null,true);
         }
         var _loc11_:Array = [];
         if(_gameInfo.currentLiving == _gameInfo.self)
         {
            _loc9_ = _gameInfo.stasticDamageList;
            for(_loc10_ in _loc9_)
            {
               if(this._damageTypeDic[_loc10_])
               {
                  _loc12_ = new DamageObject();
                  _loc12_.playerName = Player(_gameInfo.livings[_loc10_]).playerInfo.NickName;
                  _loc12_.isSelf = true;
                  _loc12_.damage = _loc9_[_loc10_];
                  _loc12_.reducePercent = this._damageTypeDic[_loc10_][_gameInfo.self.LivingID];
                  _loc11_.push(_loc12_);
               }
            }
         }
         else
         {
            _loc9_ = _gameInfo.stasticHurtList;
            for(_loc10_ in _loc9_)
            {
               if(this._damageTypeDic[_gameInfo.self.LivingID])
               {
                  _loc12_ = new DamageObject();
                  _loc12_.playerName = Player(_gameInfo.livings[_loc10_]).playerInfo.NickName;
                  _loc12_.isSelf = false;
                  _loc12_.damage = _loc9_[_loc10_];
                  _loc12_.reducePercent = this._damageTypeDic[_gameInfo.self.LivingID][_loc10_];
                  _loc11_.push(_loc12_);
               }
            }
         }
         this._damageStasticView.setInfoList(_loc11_);
         if(_gameInfo.currentLiving && _gameInfo.getTeamLiveCount(_gameInfo.currentLiving.team) > 1)
         {
            this.playFightMovie(true);
         }
         _gameInfo.resetReady();
         this._playerUsePropView.hide();
      }
      
      private function playFightMovie(param1:Boolean = false) : void
      {
         var _loc2_:Living = null;
         var _loc3_:int = 0;
         var _loc5_:Player = null;
         var _loc6_:Object = null;
         var _loc7_:Living = null;
         var _loc8_:Object = null;
         var _loc9_:Vector.<GamePlayer> = null;
         var _loc10_:PhysicalObj = null;
         var _loc11_:Vector.<ShootBombAction> = null;
         var _loc12_:Array = null;
         var _loc13_:CrazyTankSocketEvent = null;
         var _loc14_:GameTurnedLiving = null;
         if(param1)
         {
            _loc9_ = new Vector.<GamePlayer>();
            for each(_loc2_ in this.mInfoDic)
            {
               if(_loc2_ is Player && _loc2_.playerInfo)
               {
                  if(this.mBombListDic[_loc2_.LivingID])
                  {
                     _loc10_ = this.getGameLivingByID(_loc2_.LivingID);
                     if(_loc10_ as GamePlayer)
                     {
                        _loc9_.push(_loc10_);
                     }
                  }
               }
            }
            map.act(new MultiPrepareShootAction(_loc9_));
            map.act(new MultiPlaySpellSkillAction(map,_loc9_));
         }
         var _loc4_:int = this.getMaxShootCount();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc11_ = new Vector.<ShootBombAction>();
            for each(_loc2_ in this.mInfoDic)
            {
               if(!this.mBombListDic[_loc2_.LivingID] || this.mBombListDic[_loc2_.LivingID].length == 0)
               {
                  this.mBombListDic.remove(_loc2_.LivingID);
                  this.mShootEventDic.remove(_loc2_.LivingID);
               }
               else
               {
                  _loc12_ = this.mBombListDic[_loc2_.LivingID].shift();
                  _loc13_ = this.mShootEventDic[_loc2_.LivingID].shift();
                  _loc14_ = this.getGameLivingByID(_loc2_.LivingID) as GameTurnedLiving;
                  if(_loc14_)
                  {
                     if(_loc12_ && _loc13_)
                     {
                        _loc11_.push(new ShootBombAction(_loc14_,_loc12_,_loc13_,_loc14_["point"].y));
                     }
                  }
               }
            }
            map.act(new MultiShootAction(_loc11_,map,_gameInfo,_loc3_ == _loc4_ - 1));
            _loc3_++;
         }
         for each(_loc6_ in this._petSkillListDic)
         {
            _loc5_ = _gameInfo.findPlayer(_loc6_["livingID"]);
            _loc5_.usePetSkill(_loc6_["skillID"],_loc6_["isUse"]);
         }
         for each(_loc8_ in this._livingBloodDic)
         {
            _loc7_ = _gameInfo.findLiving(_loc8_["livingID"]);
            _loc7_.updateBlood(_loc8_["blood"],_loc8_["type"],_loc8_["addValue"]);
         }
      }
      
      private function getMaxShootCount() : int
      {
         var _loc2_:Array = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.mBombListDic)
         {
            _loc1_ = Math.max(_loc1_,_loc2_.length);
         }
         return _loc1_;
      }
      
      private function doShootBombs(param1:Living) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.mBombListDic[param1.LivingID].length)
         {
            param1.shoot(this.mBombListDic[param1.LivingID][_loc2_],this.mShootEventDic[param1.LivingID][_loc2_]);
            _loc2_++;
         }
      }
      
      private function clearRemovePlayer() : void
      {
         map.act(new MultiRemovePlayerAction(this._playerRemoveList,_players));
      }
      
      private function clearBombs(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.playFightMovie();
         }
         this.mInfoDic.clear();
         this.mBombListDic.clear();
         this.mShootEventDic.clear();
         this._petSkillListDic.clear();
         this._livingBloodDic.clear();
         this._damageTypeDic.clear();
      }
      
      private function __suicide(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc2_.die();
         }
      }
      
      private function __changeBall(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:Player = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_ && _loc2_ is Player)
         {
            _loc3_ = _loc2_ as Player;
            _loc4_ = param1.pkg.readBoolean();
            _loc5_ = param1.pkg.readInt();
            _map.act(new ChangeBallAction(_loc3_,_loc4_,_loc5_));
         }
      }
      
      private function __playerUsingItem(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:DisplayObject = null;
         var _loc10_:String = null;
         var _loc11_:Living = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc2_.readInt());
         var _loc6_:Living = _gameInfo.findLiving(_loc2_.extend1);
         var _loc7_:int = _loc2_.readInt();
         var _loc8_:Boolean = _loc2_.readBoolean();
         if(_loc6_ && _loc5_)
         {
            if(_loc6_.isPlayer())
            {
               if(_loc5_.CategoryID == EquipType.Freeze)
               {
                  Player(_loc6_).skill == -1;
               }
               if(!(_loc6_ as Player).isSelf)
               {
                  if(EquipType.isHolyGrail(_loc5_))
                  {
                     _loc9_ = (_loc6_ as Player).currentDeputyWeaponInfo.getDeputyWeaponIcon();
                     _loc9_.x += 7;
                     (_loc6_ as Player).useItemByIcon(_loc9_);
                  }
                  else
                  {
                     (_loc6_ as Player).useItem(_loc5_);
                     _loc10_ = EquipType.hasPropAnimation(_loc5_);
                     if(_loc10_ != null)
                     {
                        if(_loc7_ != -1)
                        {
                           _loc11_ = _gameInfo.findLiving(_loc7_);
                           if(_loc11_ && _loc11_.LivingID != _loc6_.LivingID)
                           {
                              _loc11_.showEffect(_loc10_);
                           }
                        }
                        else
                        {
                           for each(_loc11_ in _gameInfo.teams[_loc6_.team])
                           {
                              if(_loc11_.isLiving)
                              {
                                 _loc11_.showEffect(_loc10_);
                              }
                           }
                        }
                     }
                  }
               }
               this._playerUsePropView.useItem(_loc6_ as Player,_loc5_);
            }
            if(!_loc6_.isLiving && _loc11_ && _loc6_.team == _loc11_.team)
            {
               MessageTipManager.getInstance().show(_loc6_.LivingID + "|" + _loc5_.TemplateID,1);
            }
            if(_loc8_)
            {
               MessageTipManager.getInstance().show(String(_loc11_.LivingID),3);
            }
         }
      }
      
      private function __updateBuff(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:FightBuffInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Boolean = _loc2_.readBoolean();
         var _loc6_:Living = _gameInfo.findLiving(_loc3_);
         if(_loc6_ && _loc4_ != -1)
         {
            if(_loc5_)
            {
               _loc7_ = BuffManager.creatBuff(_loc4_);
               _loc6_.addBuff(_loc7_);
            }
            else
            {
               _loc6_.removeBuff(_loc4_);
            }
         }
      }
      
      private function __updatePetBuff(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:String = _loc2_.readUTF();
         var _loc6_:String = _loc2_.readUTF();
         var _loc7_:String = _loc2_.readUTF();
         var _loc8_:String = _loc2_.readUTF();
         var _loc9_:Boolean = _loc2_.readBoolean();
         var _loc10_:Living = _gameInfo.findLiving(_loc3_);
         var _loc11_:FightBuffInfo = new FightBuffInfo(_loc4_);
         _loc11_.buffPic = _loc7_;
         _loc11_.buffEffect = _loc8_;
         _loc11_.type = BuffType.PET_BUFF;
         _loc11_.buffName = _loc5_;
         _loc11_.description = _loc6_;
         if(_loc10_)
         {
            if(_loc9_)
            {
               _loc10_.addPetBuff(_loc11_);
            }
            else
            {
               _loc10_.removePetBuff(_loc11_);
            }
         }
      }
      
      private function __startMove(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:PickBoxAction = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Player = _gameInfo.findPlayer(param1.pkg.extend1);
         var _loc4_:int = _loc2_.readByte();
         var _loc5_:Point = new Point(_loc2_.readInt(),_loc2_.readInt());
         var _loc6_:int = _loc2_.readByte();
         var _loc7_:Boolean = _loc2_.readBoolean();
         if(_loc4_ == 2)
         {
            _loc8_ = [];
            _loc9_ = _loc2_.readInt();
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               _loc11_ = new PickBoxAction(_loc2_.readInt(),_loc2_.readInt());
               _loc8_.push(_loc11_);
               _loc10_++;
            }
            if(_loc3_)
            {
               _loc3_.playerMoveTo(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
            }
         }
         else if(_loc3_)
         {
            _loc3_.playerMoveTo(_loc4_,_loc5_,_loc6_,_loc7_);
         }
      }
      
      private function __onLivingBoltmove(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc3_)
         {
            _loc3_.pos = new Point(_loc2_.readInt(),_loc2_.readInt());
         }
      }
      
      private function __playerBlood(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:Object = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc6_)
         {
            if(_loc6_.playerInfo && this._playerRemoveList[_loc6_.LivingID])
            {
               return;
            }
            if(_gameInfo.getTeamLiveCount(_loc6_.team) > 1 && _loc3_ == Living.SAVE_WOUND)
            {
               _loc7_ = new Object();
               _loc7_["livingID"] = _loc6_.LivingID;
               _loc7_["blood"] = _loc4_;
               _loc7_["type"] = _loc3_;
               _loc7_["addValue"] = _loc5_;
               this._livingBloodDic.add(_loc6_.LivingID,_loc7_);
            }
            else
            {
               _loc6_.updateBlood(_loc4_,_loc3_,_loc5_);
            }
         }
      }
      
      private function __changWind(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         _map.wind = _loc2_.readInt() / 10;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readByte();
         var _loc5_:int = _loc2_.readByte();
         var _loc6_:int = _loc2_.readByte();
         var _loc7_:Array = new Array();
         _loc7_ = [_loc3_,_loc4_,_loc5_,_loc6_];
         _vane.update(_map.wind,false,_loc7_);
      }
      
      private function __playerNoNole(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc2_.isNoNole = param1.pkg.readBoolean();
         }
      }
      
      private function __onChangePlayerTarget(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         if(_loc2_ == 0)
         {
            if(_playerThumbnailLController)
            {
               _playerThumbnailLController.currentBoss = null;
            }
            return;
         }
         var _loc3_:Living = _gameInfo.findLiving(_loc2_);
         _playerThumbnailLController.currentBoss = _loc3_;
      }
      
      private function __objectSetProperty(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:GameLiving = this.getGameLivingByID(param1.pkg.extend1) as GameLiving;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:String = param1.pkg.readUTF();
         var _loc4_:String = param1.pkg.readUTF();
         this.setProperty(_loc2_,_loc3_,_loc4_);
      }
      
      private function setProperty(param1:GameLiving, param2:String, param3:String) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Living = null;
         var _loc4_:StringObject = new StringObject(param3);
         switch(param2)
         {
            case "system":
               if(param1)
               {
                  _loc5_ = 0;
                  _loc6_ = _loc4_.getBoolean();
                  _loc7_ = param1.info;
                  _loc7_.LockType = _loc5_;
                  _loc7_.LockState = _loc6_;
                  if(param1.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _loc6_;
                     GameManager.Instance.Current.selfGamePlayer.lockFly = _loc6_;
                     GameManager.Instance.Current.selfGamePlayer.lockSpellKill = _loc6_;
                     GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = !_loc6_;
                     GameManager.Instance.Current.selfGamePlayer.weaponPropEnbled = !_loc6_;
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = !_loc6_;
                     GameManager.Instance.Current.selfGamePlayer.petSkillEnabled = !_loc6_;
                  }
               }
               break;
            case "silencedSpecial":
               if(param1)
               {
                  _loc5_ = 3;
                  _loc6_ = _loc4_.getBoolean();
                  _loc7_ = param1.info;
                  _loc7_.LockType = _loc5_;
                  _loc7_.LockState = _loc6_;
                  if(param1.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _loc6_;
                     GameManager.Instance.Current.selfGamePlayer.lockFly = _loc6_;
                     GameManager.Instance.Current.selfGamePlayer.lockSpellKill = _loc6_;
                     GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = !_loc6_;
                     GameManager.Instance.Current.selfGamePlayer.weaponPropEnbled = !_loc6_;
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = !_loc6_;
                  }
               }
               break;
            case "silenced":
               if(param1)
               {
                  _loc5_ = 1;
                  _loc6_ = _loc4_.getBoolean();
                  _loc7_ = param1.info;
                  _loc7_.LockType = _loc5_;
                  _loc7_.LockState = _loc6_;
                  if(param1.info.isSelf)
                  {
                     GameManager.Instance.Current.selfGamePlayer.rightPropEnabled = !_loc6_;
                     GameManager.Instance.Current.selfGamePlayer.customPropEnabled = !_loc6_;
                     GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _loc6_;
                  }
               }
               break;
            case "nofly":
               _loc5_ = 2;
               _loc6_ = _loc4_.getBoolean();
               _loc7_ = param1.info;
               _loc7_.LockType = _loc5_;
               _loc7_.LockState = _loc6_;
               if(param1.info.isSelf)
               {
                  GameManager.Instance.Current.selfGamePlayer.lockFly = _loc6_;
               }
               break;
            case "silenceMany":
               _loc5_ = 1;
               _loc6_ = _loc4_.getBoolean();
               _loc7_ = param1.info;
               if(_loc6_)
               {
                  _loc7_.addBuff(BuffManager.creatBuff(BuffType.LockState));
               }
               else
               {
                  _loc7_.removeBuff(BuffType.LockState);
               }
               if(param1.info.isSelf)
               {
                  GameManager.Instance.Current.selfGamePlayer.lockDeputyWeapon = _loc6_;
                  GameManager.Instance.Current.selfGamePlayer.lockFly = _loc6_;
                  GameManager.Instance.Current.selfGamePlayer.lockRightProp = _loc6_;
               }
               break;
            case "hideBossThumbnail":
               if(param1)
               {
                  _playerThumbnailLController.removeThumbnailContainer();
               }
               break;
            case "diefight":
               if(param1)
               {
                  GameManager.Instance.isDieFight = true;
                  _loc7_ = param1.info;
                  _loc7_.DieFightBuffEnabled = _loc4_.getBoolean();
               }
            default:
               param1.setProperty(param2,param3);
         }
      }
      
      private function __usePetSkill(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.extend1;
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Boolean = _loc2_.readBoolean();
         var _loc6_:Player = _gameInfo.findPlayer(_loc3_);
         var _loc7_:Object = new Object();
         if(_loc6_ && _loc6_.currentPet && _loc5_)
         {
            if(_loc6_.isPlayer() && _gameInfo.getTeamLiveCount(_loc6_.team) > 1 && PetSkillManager.instance.getSkillByID(_loc4_).BallType == PetSkillInfo.BALL_TYPE_2)
            {
               _loc7_["livingID"] = _loc3_;
               _loc7_["skillID"] = _loc4_;
               _loc7_["isUse"] = _loc5_;
               this._petSkillListDic.add(_loc3_,_loc7_);
               _loc6_.isReady = true;
               _loc6_.isAttacking = false;
               if(_loc6_.isSelf)
               {
                  GameManager.Instance.Current.selfGamePlayer.beginShoot();
               }
            }
            else
            {
               _loc6_.usePetSkill(_loc4_,_loc5_);
            }
         }
         if(!_loc5_)
         {
            GameManager.Instance.dispatchEvent(new LivingEvent(LivingEvent.PETSKILL_USED_FAIL));
         }
      }
      
      private function __playerHide(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         var _loc3_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            _map.act(new UpdateStateAction(_loc2_,{"isHidden":_loc3_}));
         }
      }
      
      private function __gameOver(param1:CrazyTankSocketEvent) : void
      {
         this.gameOver();
         this._damageStasticView.start();
         this._playerUsePropView.clear();
         _map.act(new GameOverAction(_map,param1,this.showExpView));
      }
      
      private function __missionOver(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:* = null;
         SoundManager.instance.stopMusic();
         this._damageStasticView.start();
         this._playerUsePropView.hide();
         this._gameOverTimer.start();
         this._missionAgain = new MissionAgainInfo();
         this._missionAgain.value = _gameInfo.missionInfo.tryagain;
         var _loc2_:DictionaryData = RoomManager.Instance.current.players;
         for(_loc3_ in _loc2_)
         {
            if(RoomPlayer(_loc2_[_loc3_]).isHost)
            {
               this._missionAgain.host = RoomPlayer(_loc2_[_loc3_]).playerInfo.NickName;
            }
         }
         _map.act(new MissionOverAction(_map,param1,this.showExpView));
      }
      
      private function __doGameOver(param1:TimerEvent) : void
      {
         this._gameOverTimer.stop();
         this._gameOverTimer.reset();
         this.gameOver();
      }
      
      override protected function gameOver() : void
      {
         PageInterfaceManager.restorePageTitle();
         super.gameOver();
         KeyboardManager.getInstance().isStopDispatching = true;
      }
      
      private function showTryAgain() : void
      {
         var _loc1_:TryAgain = new TryAgain(this._missionAgain);
         _loc1_.addEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         _loc1_.addEventListener(GameEvent.GIVEUP,this.__giveup);
         _loc1_.addEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         _loc1_.show();
         addChild(_loc1_);
      }
      
      private function __tryAgainTimeOut(param1:GameEvent) : void
      {
         param1.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         param1.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         param1.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(this._expView)
         {
            this._expView.close();
         }
         this._expView = null;
         if(RoomManager.Instance.current && RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
         {
            StateManager.setState(StateType.SINGLEDUNGEON);
         }
      }
      
      private function resetBossPlayerStatues() : void
      {
         if(GameManager.Instance.Current)
         {
            GameManager.Instance.Current.selfGamePlayer.typeLiving = LivingTypesEnum.NORMAL_PLAYER;
         }
         if(GameManager.Instance.Current.selfGamePlayer.isBoss)
         {
            SingleDungeonManager.Instance.setBossPetNull();
         }
      }
      
      private function showExpView() : void
      {
         LayerManager.Instance.clearnGameTop();
         var _loc1_:GameInfo = GameManager.Instance.Current;
         var _loc2_:RoomInfo = RoomManager.Instance.current;
         this.resetBossPlayerStatues();
         if(ChatManager.Instance.input.parent)
         {
            ChatManager.Instance.switchVisible();
         }
         ChatManager.Instance.state = ChatManager.CHAT_GAMEOVER_STATE;
         MenoryUtil.clearMenory();
         if(_loc1_.roomType == 14)
         {
            StateManager.setState(StateType.WORLDBOSS_ROOM);
            return;
         }
         var _loc3_:int = GameManager.Instance.Current.roomType;
         var _loc4_:DungeonInfo = MapManager.getDungeonInfo(_loc2_.mapId);
         if(_loc3_ != RoomInfo.SINGLE_DUNGEON && _loc3_ != RoomInfo.CHALLENGE_ROOM && _loc3_ != RoomInfo.SINGLE_ROOM && _loc3_ != RoomInfo.MATCH_ROOM && _loc3_ != RoomInfo.CONSORTION_MONSTER && _loc3_ != RoomInfo.MULTI_MATCH && _loc3_ != RoomInfo.HIJACK_CAR && _loc3_ != RoomInfo.ARENA && _loc3_ != RoomInfo.FIGHT_ROBOT)
         {
            this._expView = new ExpView(_map.mapBitmap);
            this._expView.addEventListener(GameEvent.EXPSHOWED,this.__expShowed);
            addChild(this._expView);
            this._expView.show();
         }
         else if(_loc3_ == RoomInfo.SINGLE_DUNGEON || _loc3_ == RoomInfo.CONSORTION_MONSTER)
         {
            this.showRemoveEffect();
            LayerManager.Instance.clearnGameDynamic();
            LayerManager.Instance.clearnStageDynamic();
            if(!_gameInfo.selfGamePlayer.isWin && this._missionAgain.value > 0)
            {
               this.showTryAgain();
            }
            else
            {
               this.showSettleMentView();
            }
         }
         else if(_loc3_ == RoomInfo.FIGHT_ROBOT)
         {
            this.showSettleMentViewFightRobot();
         }
         else
         {
            this.showSettleMentViewPVP();
         }
      }
      
      private function showSettleMentView() : void
      {
         this._settlement = new SettlementView();
         addChild(this._settlement);
      }
      
      private function showSettleMentViewPVP() : void
      {
         this._settlementPVP = new SettlementViewPVP();
         addChild(this._settlementPVP);
      }
      
      private function showSettleMentViewFightRobot() : void
      {
         this._settlementFightRobot = new SettlementViewFightRobot();
         addChild(this._settlementFightRobot);
      }
      
      private function showRemoveEffect() : void
      {
         var t1:TweenLite = null;
         var t2:TweenLite = null;
         var t3:TweenLite = null;
         var t4:TweenLite = null;
         var t5:TweenLite = null;
         t1 = TweenLite.to(_vane,0.6,{
            "y":-86,
            "ease":Sine.easeIn,
            "onComplete":function():void
            {
               t1.kill();
            }
         });
         t2 = TweenLite.to(_playerThumbnailLController,0.6,{
            "y":-86,
            "ease":Sine.easeIn,
            "onComplete":function():void
            {
               t2.kill();
            }
         });
         t3 = TweenLite.to(_map.smallMap,0.6,{
            "x":1114,
            "ease":Sine.easeIn,
            "onComplete":function():void
            {
               t3.kill();
            }
         });
         if(currentControllState)
         {
            t4 = TweenLite.to(currentControllState,0.6,{
               "y":662,
               "alpha":0,
               "ease":Sine.easeIn,
               "onComplete":function():void
               {
                  t4.kill();
               }
            });
         }
         if(_leftPlayerView)
         {
            t5 = TweenLite.to(_leftPlayerView,0.65,{
               "x":-205,
               "ease":Sine.easeIn,
               "onComplete":function():void
               {
                  t5.kill();
               }
            });
         }
      }
      
      private function __expShowed(param1:GameEvent) : void
      {
         var _loc2_:Living = null;
         var _loc3_:Living = null;
         this._expView.removeEventListener(GameEvent.EXPSHOWED,this.__expShowed);
         for each(_loc2_ in _gameInfo.livings.list)
         {
            if(_loc2_.isSelf)
            {
               if(Player(_loc2_).isWin && this._missionAgain)
               {
                  this._missionAgain.win = true;
               }
               if(Player(_loc2_).hasLevelAgain && this._missionAgain)
               {
                  this._missionAgain.hasLevelAgain = true;
               }
            }
         }
         for each(_loc3_ in _gameInfo.viewers.list)
         {
            if(_loc3_.isSelf)
            {
               if(Player(_loc3_).isWin && this._missionAgain)
               {
                  this._missionAgain.win = true;
               }
               if(Player(_loc3_).hasLevelAgain && this._missionAgain)
               {
                  this._missionAgain.hasLevelAgain = true;
               }
            }
         }
         if(GameManager.isDungeonRoom(_gameInfo) && _gameInfo.missionInfo.tryagain > 0)
         {
            if(RoomManager.Instance.current.selfRoomPlayer.isViewer && !this._missionAgain.win)
            {
               this.showTryAgain();
               if(this._expView)
               {
                  this._expView.visible = false;
               }
            }
            else if(RoomManager.Instance.current.selfRoomPlayer.isViewer && this._missionAgain.win)
            {
               if(this._expView)
               {
                  this._expView.close();
               }
               this._expView = null;
            }
            else if(!_gameInfo.selfGamePlayer.isWin)
            {
               this.showTryAgain();
               if(this._expView)
               {
                  this._expView.visible = false;
               }
            }
            else
            {
               this._expView.showCard();
               this._expView = null;
            }
         }
         else if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._expView.close();
            this._expView = null;
         }
         else if(RoomManager.Instance.current.type == RoomInfo.HIJACK_CAR)
         {
            this._expView.close();
            this._expView = null;
         }
         else
         {
            this._expView.showCard();
            this._expView = null;
         }
      }
      
      private function __giveup(param1:GameEvent) : void
      {
         param1.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         param1.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         param1.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendMissionTryAgain(GameManager.MissionGiveup,true);
         }
         if(this._expView)
         {
            this._expView.close();
            this._expView = null;
         }
         if(RoomManager.Instance.current)
         {
            if(RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
            {
               StateManager.setState(StateType.SINGLEDUNGEON);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.CONSORTION_MONSTER)
            {
               StateManager.setState(StateType.CONSORTIA);
            }
         }
      }
      
      private function __tryAgain(param1:GameEvent) : void
      {
         param1.currentTarget.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         param1.currentTarget.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         param1.currentTarget.removeEventListener(GameEvent.TIMEOUT,this.__tryAgainTimeOut);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(!RoomManager.Instance.current.selfRoomPlayer.isViewer || GameManager.Instance.TryAgain == GameManager.MissionAgain)
         {
            GameManager.Instance.Current.hasNextMission = true;
         }
         if(this._expView)
         {
            this._expView.close();
            this._expView = null;
         }
         if(RoomManager.Instance.current.type == RoomInfo.SINGLE_DUNGEON)
         {
            GameInSocketOut.sendGameMissionStart(true);
            GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         }
      }
      
      protected function __startLoading(param1:Event) : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         LayerManager.Instance.clearnGameDynamic();
         GameManager.Instance.gotoRoomLoading();
         StateManager.getInGame_Step_7 = true;
      }
      
      private function __dander(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_ && _loc2_ is Player)
         {
            _loc3_ = param1.pkg.readInt();
            (_loc2_ as Player).dander = _loc3_;
         }
      }
      
      private function __reduceDander(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_ && _loc2_ is Player)
         {
            _loc3_ = param1.pkg.readInt();
            (_loc2_ as Player).reduceDander(_loc3_);
         }
      }
      
      private function __changeState(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc2_.State = param1.pkg.readInt();
            _map.setCenter(_loc2_.pos.x,_loc2_.pos.y,true,AnimationLevel.MIDDLE,_loc2_.LivingID);
         }
      }
      
      private function __selfObtainItem(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:PropInfo = null;
         var _loc4_:AutoDisappear = null;
         var _loc5_:AutoDisappear = null;
         var _loc6_:AutoDisappear = null;
         var _loc7_:MovieClipWrapper = null;
         for each(_loc2_ in param1.changedSlots)
         {
            _loc3_ = new PropInfo(_loc2_);
            _loc3_.Place = _loc2_.Place;
            if(PlayerManager.Instance.Self.FightBag.getItemAt(_loc2_.Place))
            {
               _loc4_ = new AutoDisappear(ComponentFactory.Instance.creatBitmap("asset.game.getPropBgAsset"),3);
               _loc4_.x = _vane.x - _loc4_.width / 2 + 48;
               _loc4_.y = _selfMarkBar.y + _selfMarkBar.height + 70;
               LayerManager.Instance.addToLayer(_loc4_,LayerManager.GAME_DYNAMIC_LAYER,false);
               _loc5_ = new AutoDisappear(PropItemView.createView(_loc3_.Template.Pic,62,62),3);
               _loc5_.x = _vane.x - _loc5_.width / 2 + 47;
               _loc5_.y = _selfMarkBar.y + _selfMarkBar.height + 70;
               LayerManager.Instance.addToLayer(_loc5_,LayerManager.GAME_DYNAMIC_LAYER,false);
               _loc6_ = new AutoDisappear(ComponentFactory.Instance.creatBitmap("asset.game.getPropCiteAsset"),3);
               _loc6_.x = _vane.x - _loc6_.width / 2 + 45;
               _loc6_.y = _selfMarkBar.y + _selfMarkBar.height + 70;
               LayerManager.Instance.addToLayer(_loc6_,LayerManager.GAME_DYNAMIC_LAYER,false);
               _loc7_ = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.zxcTip"),true,true);
               _loc7_.movie.x += _loc7_.movie.width * _loc2_.Place - this.ZXC_OFFSET * _loc2_.Place;
               LayerManager.Instance.addToLayer(_loc7_.movie,LayerManager.GAME_UI_LAYER,false);
            }
         }
      }
      
      private function __getTempItem(param1:BagEvent) : void
      {
         var _loc2_:Boolean = GameManager.Instance.selfGetItemShowAndSound(param1.changedSlots);
         if(_loc2_ && this._soundPlayFlag)
         {
            this._soundPlayFlag = false;
            SoundManager.instance.play("1001");
         }
      }
      
      private function __forstPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _map.act(new UpdateStateAction(_loc2_,{"isFrozen":param1.pkg.readBoolean()}));
         }
      }
      
      private function __changeShootCount(param1:CrazyTankSocketEvent) : void
      {
         if(_gameInfo.findPlayer(param1.pkg.extend1).playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            _gameInfo.selfGamePlayer.shootCount = param1.pkg.readByte();
         }
      }
      
      private function __playSound(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = param1.pkg.readUTF();
         SoundManager.instance.initSound(_loc2_);
         SoundManager.instance.play(_loc2_);
      }
      
      private function __controlBGM(param1:CrazyTankSocketEvent) : void
      {
         if(param1.pkg.readBoolean())
         {
            SoundManager.instance.resumeMusic();
         }
         else
         {
            SoundManager.instance.pauseMusic();
         }
      }
      
      private function __forbidDragFocus(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         _map.smallMap.allowDrag = _loc2_;
      }
      
      override protected function defaultForbidDragFocus() : void
      {
         _map.smallMap.allowDrag = true;
      }
      
      private function __topLayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.readInt());
         if(_loc2_)
         {
            _map.bringToFront(_loc2_);
         }
      }
      
      private function __loadResource(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:GameNeedMovieInfo = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new GameNeedMovieInfo();
            _loc4_.type = param1.pkg.readInt();
            _loc4_.path = param1.pkg.readUTF();
            _loc4_.classPath = param1.pkg.readUTF();
            _loc4_.startLoad();
            _loc3_++;
         }
      }
      
      private function __livingShowBlood(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = Boolean(param1.pkg.readInt());
         (_map.getPhysical(_loc2_) as GameLiving).showBlood(_loc3_);
      }
      
      private function __livingShowNpc(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:Boolean = Boolean(param1.pkg.readInt());
         (_map.getPhysical(_loc2_) as GameLiving).showNpc(_loc3_);
      }
      
      private function __livingActionMapping(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:String = param1.pkg.readUTF();
         var _loc4_:String = param1.pkg.readUTF();
         if(_map.getPhysical(_loc2_))
         {
            _map.getPhysical(_loc2_).setActionMapping(_loc3_,_loc4_);
         }
      }
      
      private function getGameLivingByID(param1:int) : PhysicalObj
      {
         if(!_map)
         {
            return null;
         }
         return _map.getPhysical(param1);
      }
      
      private function addStageCurtain(param1:SimpleObject) : void
      {
         var obj:SimpleObject = param1;
         obj.movie.addEventListener("playEnd",function():void
         {
            obj.movie.stop();
            if(obj.parent)
            {
               obj.parent.removeChild(obj);
            }
            obj.dispose();
            obj = null;
         });
         addChild(obj);
      }
      
      private function __onDropItemComplete(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:DisplayObject = null;
         var _loc12_:Point = null;
         var _loc13_:Point = null;
         var _loc14_:DropGoods = null;
         var _loc15_:Class = null;
         var _loc16_:ItemTemplateInfo = null;
         var _loc17_:BaseCell = null;
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.bytesAvailable < 1)
         {
            return;
         }
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc2_.readInt();
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = _loc2_.readInt();
               _loc10_ = _loc2_.readInt();
               _loc9_ = EquipType.filterEquiqItemId(_loc9_);
               if(_loc9_ == -400)
               {
                  if(ModuleLoader.hasDefinition("asset.game.dropEffect.magicSoul"))
                  {
                     _loc15_ = ModuleLoader.getDefinition("asset.game.dropEffect.magicSoul");
                     _loc11_ = new _loc15_();
                  }
               }
               else
               {
                  _loc16_ = ItemManager.Instance.getTemplateById(_loc9_);
                  _loc17_ = new BaseCell(new Sprite(),_loc16_,false,false);
                  _loc17_.setContentSize(40,40);
                  _loc11_ = _loc17_;
               }
               _loc12_ = new Point(_loc3_,_loc4_);
               if(_selfGamePlayer)
               {
                  _loc13_ = new Point(_selfGamePlayer.x,_selfGamePlayer.y - 30);
               }
               else if(_selfTurnedLiving)
               {
                  _loc13_ = new Point(_selfTurnedLiving.x,_selfTurnedLiving.y - 30);
               }
               if(_loc9_ == EquipType.GOLD)
               {
                  GameManager.Instance.dropGlod += _loc10_;
               }
               else
               {
                  GameManager.Instance.setDropData(_loc9_,_loc10_);
               }
               _loc14_ = new DropGoods(this.map,_loc11_,_loc12_,_loc13_,_loc10_);
               GameManager.Instance.dropGoodslist.push(_loc14_);
               _loc8_++;
            }
            _loc6_++;
         }
      }
      
      private function __useFightKitSkillSocket(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Dictionary = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ != 0)
         {
            _loc4_ = _loc2_.readInt();
            _loc5_ = _map.getPhysicalAll();
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc7_ = _loc2_.readInt();
               this._enermy.push(_loc5_[_loc7_]);
               _loc6_++;
            }
            this._timer.addEventListener(TimerEvent.TIMER,this.__skillTimer);
            this._timer.start();
            if(_map && _map.currentPlayer && _map.currentPlayer.playerInfo && _loc2_.extend1 == PlayerManager.Instance.Self.ID)
            {
               PlayerManager.Instance.Self.dispatchEvent(new LivingEvent(LivingEvent.FIGHT_TOOL_BOX_CHANGED));
            }
         }
      }
      
      private function __skillTimer(param1:TimerEvent) : void
      {
         var _loc2_:GameLiving = null;
         if(this._enermy.length > 0)
         {
            _loc2_ = this._enermy.shift();
            if(_loc2_)
            {
               _map.animateSet.addAnimation(new ShockMapAnimation(_loc2_,14));
               _loc2_.playFightToolBoxSkill();
               map.animateSet.addAnimation(new PhysicalObjFocusAnimation(_loc2_,10,0,AnimationLevel.MIDDLE,AnimationSet.PUBLIC_OWNER));
            }
         }
         else
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__skillTimer);
         }
      }
      
      private function __petReduce(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.extend1;
         var _loc3_:Living = _gameInfo.findLiving(_loc2_);
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:GameLiving = this.getGameLivingByID(_loc3_.LivingID) as GameLiving;
         var _loc6_:ShootPercentView = new ShootPercentView(_loc4_,21);
         _loc6_.x = _loc5_.x - 50 + _loc5_.offset();
         _loc6_.y = _loc5_.y - 50 - _loc5_.offset();
         _map.addToPhyLayer(_loc6_);
         GameManager.Instance.petReduceList.push(_loc6_);
      }
      
      protected function __playerEndFire(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Living = _gameInfo.findLiving(param1.pkg.extend1);
         if(_loc2_)
         {
            _loc2_.isReady = true;
         }
      }
      
      protected function __bombComplete(param1:GameEvent) : void
      {
         this._damageStasticView.start();
      }
      
      override protected function __attackingChanged(param1:LivingEvent) : void
      {
         super.__attackingChanged(param1);
         if(Player(param1.target).isAttacking)
         {
            this.recoverScreen();
         }
      }
      
      private function hideScreen() : void
      {
         if(_selfBuffBar)
         {
            _selfBuffBar.visible = false;
         }
         if(_selfMarkBar)
         {
            _selfMarkBar.visible = false;
         }
      }
      
      private function recoverScreen() : void
      {
         if(_selfBuffBar)
         {
            _selfBuffBar.visible = true;
         }
         if(_selfMarkBar)
         {
            _selfMarkBar.visible = true;
         }
      }
   }
}