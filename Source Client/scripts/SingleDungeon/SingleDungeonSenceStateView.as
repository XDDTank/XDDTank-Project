package SingleDungeon
{
   import SingleDungeon.model.SingleDungeonPlayerInfo;
   import SingleDungeon.view.SingleDungeonWalkMapView;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.InviteManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class SingleDungeonSenceStateView extends BaseStateView
   {
      
      public static const MAX_PLAYER_COUNT:int = 5;
      
      private static var _instance:SingleDungeonSenceStateView;
       
      
      private var _view:SingleDungeonWalkMapView;
      
      public function SingleDungeonSenceStateView()
      {
         super();
      }
      
      public static function get Instance() : SingleDungeonSenceStateView
      {
         if(!_instance)
         {
            _instance = new SingleDungeonSenceStateView();
         }
         return _instance;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         super.enter(param1,param2);
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         MainToolBar.Instance.show();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._view = new SingleDungeonWalkMapView(this,SingleDungeonManager.Instance._singleDungeonWalkMapModel);
         this._view.show();
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_INFO,this.__addPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_MOVE,this.__movePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_EXIT,this.__removePlayer);
      }
      
      public function __addPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:PlayerInfo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:SingleDungeonPlayerInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         if(param1.pkg.bytesAvailable > 10)
         {
            _loc3_ = new PlayerInfo();
            _loc3_.beginChanges();
            _loc3_.Grade = _loc2_.readInt();
            _loc3_.Hide = _loc2_.readInt();
            _loc3_.Repute = _loc2_.readInt();
            _loc3_.ID = _loc2_.readInt();
            _loc3_.NickName = _loc2_.readUTF();
            _loc3_.VIPtype = _loc2_.readByte();
            _loc3_.VIPLevel = _loc2_.readInt();
            _loc3_.Sex = _loc2_.readBoolean();
            _loc3_.Style = _loc2_.readUTF();
            _loc3_.Colors = _loc2_.readUTF();
            _loc3_.Skin = _loc2_.readUTF();
            _loc4_ = _loc2_.readInt();
            _loc5_ = _loc2_.readInt();
            _loc3_.FightPower = _loc2_.readInt();
            _loc3_.WinCount = _loc2_.readInt();
            _loc3_.TotalCount = _loc2_.readInt();
            _loc3_.Offer = _loc2_.readInt();
            _loc3_.commitChanges();
            _loc6_ = new SingleDungeonPlayerInfo();
            _loc6_.playerInfo = _loc3_;
            _loc6_.playerPos = new Point(_loc4_,_loc5_);
            if(_loc3_.ID == PlayerManager.Instance.Self.ID)
            {
               return;
            }
            SingleDungeonManager.Instance._singleDungeonWalkMapModel.addPlayer(_loc6_);
            SingleDungeonManager.Instance._singleDungeonWalkMapModel.removeRobot();
         }
      }
      
      public function __removePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            StateManager.setState(this.getBackType());
         }
         else
         {
            SingleDungeonManager.Instance._singleDungeonWalkMapModel.removePlayer(_loc2_);
            SingleDungeonManager.Instance._singleDungeonWalkMapModel.addPlayer(SingleDungeonManager.Instance.robotList.pop());
         }
      }
      
      public function __movePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc9_:Point = null;
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:String = param1.pkg.readUTF();
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         var _loc6_:Array = _loc5_.split(",");
         var _loc7_:Array = [];
         var _loc8_:uint = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = new Point(_loc6_[_loc8_],_loc6_[_loc8_ + 1]);
            _loc7_.push(_loc9_);
            _loc8_ += 2;
         }
         this._view.movePlayer(_loc2_,_loc7_);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         SocketManager.Instance.out.sendExitWalkScene();
         this.removeEvent();
         if(this._view)
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         super.leaving(param1);
      }
      
      override public function getBackType() : String
      {
         return StateType.SINGLEDUNGEON;
      }
      
      override public function getType() : String
      {
         return StateType.SINGLEDUNGEON_WALK_MAP;
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_INFO,this.__addPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_MOVE,this.__movePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_EXIT,this.__removePlayer);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._view = null;
      }
   }
}
