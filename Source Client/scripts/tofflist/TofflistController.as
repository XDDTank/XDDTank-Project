package tofflist
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.PlayerManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import flash.display.DisplayObject;
   import tofflist.view.TofflistMainFrame;
   
   public class TofflistController extends BaseStateView
   {
      
      private static var _instance:TofflistController;
       
      
      private var _view:TofflistMainFrame;
      
      private var _temporaryTofflistListData:String;
      
      public function TofflistController()
      {
         super();
      }
      
      public static function get Instance() : TofflistController
      {
         if(_instance == null)
         {
            _instance = new TofflistController();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.openToffilist();
      }
      
      private function openToffilist() : void
      {
         this.init();
         this._view.addEvent();
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         if(TofflistModel.Instance.rankInfo == null)
         {
            TofflistModel.Instance.loadRankInfo();
         }
      }
      
      private function init() : void
      {
         this._view = ComponentFactory.Instance.creatCustomObject("ddtTofflistMainFrame",[this]);
         this._view.show();
         this.loadFormData("personalBattleAccumulate");
      }
      
      override public function getView() : DisplayObject
      {
         return this._view;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this.init();
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         if(TofflistModel.Instance.rankInfo == null)
         {
            TofflistModel.Instance.loadRankInfo();
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._view);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.dispose();
         super.leaving(param1);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.TOFFLIST;
      }
      
      public function loadFormData(param1:String) : void
      {
         TofflistModel.Instance[param1] = TofflistModel.Instance[param1];
      }
      
      public function clearDisplayContent() : void
      {
         this._view.clearDisplayContent();
      }
      
      public function loadList(param1:int) : void
      {
      }
   }
}
