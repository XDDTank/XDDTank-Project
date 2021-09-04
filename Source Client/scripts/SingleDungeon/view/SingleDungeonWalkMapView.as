package SingleDungeon.view
{
   import SingleDungeon.SingleDungeonSenceStateView;
   import SingleDungeon.event.SingleDungeonEvent;
   import SingleDungeon.model.SingleDungeonWalkMapModel;
   import church.vo.SceneMapVO;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.DialogManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.PlayerPortraitView;
   import ddt.view.chat.ChatView;
   import ddt.view.common.LevelIcon;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class SingleDungeonWalkMapView extends Sprite implements Disposeable
   {
      
      public static const MAP_SIZEII:Array = [5000,5000];
       
      
      private var _stateView:SingleDungeonSenceStateView;
      
      private var _walkMapModel:SingleDungeonWalkMapModel;
      
      private var _sceneScene:SceneScene;
      
      private var _sceneMap:SingleDungeonSenceMap;
      
      private var _chatFrame:ChatView;
      
      private var _headBoxBitm:Bitmap;
      
      private var _headBox:Sprite;
      
      private var _playerHeadView:PlayerPortraitView;
      
      private var _levelIcon:LevelIcon;
      
      public function SingleDungeonWalkMapView(param1:SingleDungeonSenceStateView, param2:SingleDungeonWalkMapModel)
      {
         super();
         this._stateView = param1;
         this._walkMapModel = param2;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._sceneScene = new SceneScene();
         ChatManager.Instance.state = ChatManager.CHAT_WORLDBOS_ROOM;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
         this.setMap();
         this.setHeadBox();
      }
      
      private function setHeadBox() : void
      {
         this._headBox = new Sprite();
         var _loc1_:SelfInfo = PlayerManager.Instance.Self;
         this._headBoxBitm = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.headBox");
         this._headBox.addChild(this._headBoxBitm);
         var _loc2_:Sprite = this.headMask();
         this._playerHeadView = ComponentFactory.Instance.creatCustomObject("singledungeon.sencemap.PortraitView",["right"]);
         this._playerHeadView.info = _loc1_;
         this._playerHeadView.isShowFrame = false;
         this._playerHeadView.mask = _loc2_;
         this._headBox.addChild(this._playerHeadView);
         this._headBox.addChild(_loc2_);
         this._headBox.x = 12;
         this._headBox.y = 12;
         this.addChild(this._headBox);
         SingleDungeonEvent.dispatcher.addEventListener(SingleDungeonEvent.WALKMAP_EXIT,this._upArrow);
      }
      
      private function _upArrow(param1:SingleDungeonEvent) : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.BACK_GUILDE,-45,"singleDungeon.missionbackArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
      }
      
      private function headMask() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(0);
         _loc1_.graphics.drawCircle(47,43,38);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      public function setMap(param1:Point = null) : void
      {
         this.clearMap();
         var _loc2_:MovieClip = ComponentFactory.Instance.creat("singleDungeon.walkScene.map" + this._walkMapModel._mapSceneModel.ID) as MovieClip;
         var _loc3_:Sprite = _loc2_.getChildByName("mesh") as Sprite;
         var _loc4_:Sprite = _loc2_.getChildByName("bg") as Sprite;
         MAP_SIZEII[0] = _loc4_.width;
         MAP_SIZEII[1] = _loc4_.height;
         this._sceneScene.setHitTester(new PathMapHitTester(_loc3_));
         if(!this._sceneMap)
         {
            this._sceneMap = new SingleDungeonSenceMap(this._sceneScene,this._walkMapModel.getPlayers(),this._walkMapModel.getObjects(),_loc4_,_loc3_);
            addChildAt(this._sceneMap,0);
         }
         this._sceneMap.sceneMapVO = this.getSceneMapVO();
         if(param1)
         {
            this._sceneMap.sceneMapVO.defaultPos = param1;
         }
         this._sceneMap.addSelfPlayer();
         this._sceneMap.setCenter();
         SoundManager.instance.playMusic("map" + this._walkMapModel._mapSceneModel.ID);
      }
      
      private function showGuide() : void
      {
         if(this._walkMapModel._mapSceneModel.ID == 2 && SavePointManager.Instance.isInSavePoint(11) && !TaskManager.instance.isNewHandTaskCompleted(3))
         {
            LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox,LayerManager.STAGE_TOP_LAYER);
            NewHandContainer.Instance.showArrow(ArrowType.TIP_CHEST,-135,"trainer.posChest2","","",this._sceneMap.getLayerByIndex(0));
         }
      }
      
      public function getSceneMapVO() : SceneMapVO
      {
         var _loc1_:SceneMapVO = new SceneMapVO();
         _loc1_.mapName = LanguageMgr.GetTranslation("church.churchScene.WeddingMainScene");
         _loc1_.mapW = MAP_SIZEII[0];
         _loc1_.mapH = MAP_SIZEII[1];
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
            this._sceneMap.updatePlayersStauts(param1,param2,param3);
         }
      }
      
      public function updateSelfStatus(param1:int) : void
      {
         this._sceneMap.updateSelfStatus(param1);
      }
      
      private function _leaveRoom(param1:Event) : void
      {
         StateManager.setState(StateType.SINGLEDUNGEON);
         this._stateView.dispose();
      }
      
      private function clearMap() : void
      {
         if(this._sceneMap)
         {
            if(this._sceneMap.parent)
            {
               this._sceneMap.parent.removeChild(this._sceneMap);
            }
            this._sceneMap.dispose();
         }
         this._sceneMap = null;
      }
      
      public function show() : void
      {
         this._stateView.addChild(this);
         this.showGuide();
      }
      
      public function dispose() : void
      {
         SingleDungeonEvent.dispatcher.removeEventListener(SingleDungeonEvent.WALKMAP_EXIT,this._upArrow);
         MainToolBar.Instance.setReturnEnable(true);
         ObjectUtils.disposeAllChildren(this);
         this._sceneScene = null;
         this._sceneMap = null;
         this._chatFrame = null;
         if(this._headBoxBitm)
         {
            ObjectUtils.disposeObject(this._headBoxBitm);
         }
         this._headBoxBitm = null;
         if(this._headBox)
         {
            ObjectUtils.disposeObject(this._headBox);
         }
         this._headBox = null;
         if(this._playerHeadView)
         {
            ObjectUtils.disposeObject(this._playerHeadView);
         }
         this._playerHeadView = null;
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
