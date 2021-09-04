package consortion.consortionsence
{
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.IConsortionState;
   import consortion.event.ConsortionMonsterEvent;
   import consortion.managers.ConsortionMonsterManager;
   import consortion.transportSence.TransportManager;
   import consortion.transportSence.TransportSenceMap;
   import consortion.view.monsterReflash.MonsterRankView;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import ddt.view.chat.ChatOutputView;
   import ddt.view.chat.ChatView;
   import ddt.view.common.LevelIcon;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ConsortionSenceWalkMapView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZE:Array = [5000,5000];
       
      
      private var _stateView:BaseStateView;
      
      private var _scenScene:SceneScene;
      
      private var _sceneMap:IConsortionState;
      
      private var _chatFrame:ChatView;
      
      private var _levelIcon:LevelIcon;
      
      private var _senceType:int = 0;
      
      private var _monsterRankView:MonsterRankView;
      
      private var _Gradebg:Bitmap;
      
      private var _consortionName:FilterFrameText;
      
      private var _level:ScaleFrameImage;
      
      private var _transportBtn:BaseButton;
      
      public function ConsortionSenceWalkMapView(param1:BaseStateView, param2:int)
      {
         super();
         this._stateView = param1;
         this._senceType = param2;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._scenScene = new SceneScene();
         ChatManager.Instance.output.channel = ChatOutputView.CHAT_OUPUT_CURRENT;
         ChatManager.Instance.view.bg = false;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         ConsortionMonsterManager.Instance.addEventListener(ConsortionMonsterEvent.MONSTER_ACTIVE_START,this.__onActiveStarted);
         this.setMap();
      }
      
      private function createGradeInfo() : void
      {
         this._Gradebg = ComponentFactory.Instance.creatBitmap("asset.consortionMap.GradeBg");
         this._consortionName = ComponentFactory.Instance.creatComponentByStylename("ConsorionMap.nameText");
         this._consortionName.text = PlayerManager.Instance.Self.ConsortiaName;
         this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.level");
         this._level.scaleX = 0.5;
         this._level.scaleY = 0.5;
         this._level.setFrame(PlayerManager.Instance.Self.consortiaInfo.Level);
         PositionUtils.setPos(this._level,"asset.consortionMap.pos");
         this._transportBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.transportBtn");
         this._transportBtn.addEventListener(MouseEvent.CLICK,this.__clickTransportBtn);
         addChild(this._Gradebg);
         addChild(this._consortionName);
         addChild(this._level);
         addChild(this._transportBtn);
      }
      
      public function setMap(param1:Point = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:Sprite = new Sprite();
         if(!this._sceneMap)
         {
            switch(this._senceType)
            {
               case ConsortionModel.CONSORTION_SENCE:
                  ChatManager.Instance.state = ChatManager.CHAT_CONSORTIA_VIEW;
                  _loc2_ = ComponentFactory.Instance.creat("consortion.walkScene.map1") as MovieClip;
                  _loc3_ = _loc2_.getChildByName("mesh") as Sprite;
                  _loc4_ = _loc2_.getChildByName("bg") as Sprite;
                  _loc5_ = _loc2_.getChildByName("hallMouse") as MovieClip;
                  _loc6_ = _loc2_.getChildByName("shopMouse") as MovieClip;
                  _loc7_ = _loc2_.getChildByName("skillMouse") as MovieClip;
                  _loc8_ = _loc2_.getChildByName("plantArea") as MovieClip;
                  _loc9_.addChild(_loc8_);
                  this._sceneMap = new ConsortionSenceMap(this._scenScene,ConsortionManager.Instance._consortionWalkMode.getPlayers(),ConsortionManager.Instance._consortionWalkMode.getObjects(),_loc4_,_loc3_,_loc5_,_loc6_,_loc7_,_loc9_);
                  this._monsterRankView = new MonsterRankView();
                  PositionUtils.setPos(this._monsterRankView,"consortion.monsterRankPos");
                  if(ConsortionMonsterManager.Instance.ActiveState)
                  {
                     this._monsterRankView.visible = true;
                     this.playBackMusic(3);
                  }
                  else
                  {
                     this._monsterRankView.visible = false;
                     this.playBackMusic(1);
                  }
                  addChild(this._monsterRankView);
                  this.createGradeInfo();
                  break;
               case ConsortionModel.CONSORTION_TRANSPORT:
                  ChatManager.Instance.state = ChatManager.CHAT_CONSORTIA_TRANSPORT_VIEW;
                  _loc2_ = ComponentFactory.Instance.creat("singleDungeon.walkScene.map6") as MovieClip;
                  _loc3_ = _loc2_.getChildByName("mesh") as Sprite;
                  _loc4_ = _loc2_.getChildByName("bg") as Sprite;
                  this.playBackMusic(2);
                  this._sceneMap = new TransportSenceMap(this._scenScene,TransportManager.Instance.transportModel.getPlayers(),TransportManager.Instance.transportModel.getObjects(),_loc4_,_loc3_);
            }
            addChildAt(this._sceneMap as Sprite,0);
         }
         MAP_SIZE[0] = _loc4_.width;
         MAP_SIZE[1] = _loc4_.height;
         this._scenScene.setHitTester(new PathMapHitTester(_loc3_));
         this._sceneMap.sceneMapVO = this.getSceneMapVO();
         if(param1)
         {
            this._sceneMap.sceneMapVO.defaultPos = param1;
         }
         this._sceneMap.addSelfPlayer();
         this._sceneMap.setCenter();
      }
      
      private function playBackMusic(param1:int) : void
      {
         switch(param1)
         {
            case 1:
               SoundManager.instance.playMusic("sceneofthesociety");
               break;
            case 2:
               SoundManager.instance.playMusic("robberypath");
               break;
            case 3:
               SoundManager.instance.playMusic("monsterinvasion");
         }
      }
      
      public function getSceneMapVO() : SceneMapVO
      {
         var _loc1_:SceneMapVO = new SceneMapVO();
         _loc1_.mapW = MAP_SIZE[0];
         _loc1_.mapH = MAP_SIZE[1];
         _loc1_.defaultPos = new Point(100,100);
         return _loc1_;
      }
      
      public function movePlayer(param1:int, param2:Array) : void
      {
         if(this._sceneMap)
         {
            this._sceneMap.movePlayer(param1,param2);
         }
      }
      
      public function updatePlayerStauts(param1:int, param2:int, param3:Point = null) : void
      {
         if(this._sceneMap)
         {
            this._sceneMap.updatePlayerStauts(param1,param2,param3);
         }
      }
      
      public function updateSelfStatus(param1:int) : void
      {
         this._sceneMap.updateSelfStatus(param1);
      }
      
      private function _leaveRoom(param1:Event) : void
      {
         StateManager.setState(StateType.CONSORTIA);
         this._stateView.dispose();
      }
      
      private function clearMap() : void
      {
         if(this._sceneMap)
         {
            ObjectUtils.disposeObject(this._sceneMap);
         }
         this._sceneMap = null;
      }
      
      public function show() : void
      {
         this._stateView.addChild(this);
      }
      
      private function __onActiveStarted(param1:ConsortionMonsterEvent) : void
      {
         if(this._monsterRankView)
         {
            this._monsterRankView.visible = param1.data as Boolean;
            this.playBackMusic(3);
         }
      }
      
      private function __clickTransportBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.SendenterConsortionTransport();
      }
      
      public function dispose() : void
      {
         ConsortionMonsterManager.Instance.removeEventListener(ConsortionMonsterEvent.MONSTER_ACTIVE_START,this.__onActiveStarted);
         MainToolBar.Instance.setReturnEnable(true);
         ObjectUtils.disposeAllChildren(this);
         this._scenScene = null;
         this._sceneMap = null;
         this._chatFrame = null;
         this._monsterRankView = null;
         this._Gradebg = null;
         this._consortionName = null;
         this._level = null;
         ObjectUtils.disposeObject(this._transportBtn);
         this._transportBtn = null;
         if(this._levelIcon)
         {
            ObjectUtils.disposeObject(this._levelIcon);
         }
         this._levelIcon = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
