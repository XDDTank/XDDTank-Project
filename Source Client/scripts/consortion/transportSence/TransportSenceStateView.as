package consortion.transportSence
{
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.consortionsence.ConsortionManager;
   import consortion.consortionsence.ConsortionSenceWalkMapView;
   import consortion.consortionsence.ConsortionWalkPlayerInfo;
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
   
   public class TransportSenceStateView extends BaseStateView
   {
       
      
      private var _view:ConsortionSenceWalkMapView;
      
      public function TransportSenceStateView()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         super.enter(param1,param2);
         MainToolBar.Instance.show();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._view = new ConsortionSenceWalkMapView(this,ConsortionModel.CONSORTION_TRANSPORT);
         this._view.show();
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIONSENCE_ADDPLAYER,this.__addPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIONSENCE_MOVEPLAYER,this.__movePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EXIT_CONSORTION,this.__removePlayer);
      }
      
      private function __addPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:PlayerInfo = new PlayerInfo();
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
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         _loc3_.FightPower = _loc2_.readInt();
         _loc3_.WinCount = _loc2_.readInt();
         _loc3_.TotalCount = _loc2_.readInt();
         _loc3_.Offer = _loc2_.readInt();
         _loc3_.commitChanges();
         var _loc6_:ConsortionWalkPlayerInfo = new ConsortionWalkPlayerInfo();
         _loc6_.playerInfo = _loc3_;
         _loc6_.playerPos = new Point(_loc4_,_loc5_);
         if(_loc3_.ID == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         TransportManager.Instance.transportModel.addPlayer(_loc6_);
      }
      
      private function __movePlayer(param1:CrazyTankSocketEvent) : void
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
      
      private function __removePlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         if(_loc2_ == PlayerManager.Instance.Self.ID)
         {
            StateManager.setState(this.getBackType());
         }
         else
         {
            ConsortionManager.Instance._consortionWalkMode.removePlayer(_loc2_);
         }
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIONSENCE_ADDPLAYER,this.__addPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIONSENCE_MOVEPLAYER,this.__movePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.EXIT_CONSORTION,this.__removePlayer);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         this.removeEvent();
         SocketManager.Instance.out.SendexitConsortionTransport();
         if(this._view)
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         super.leaving(param1);
      }
      
      override public function getType() : String
      {
         return StateType.CONSORTION_TRANSPORT;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._view = null;
      }
   }
}
