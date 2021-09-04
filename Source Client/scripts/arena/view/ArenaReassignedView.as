package arena.view
{
   import arena.ArenaManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.TimeEvents;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import flash.events.MouseEvent;
   
   public class ArenaReassignedView extends BaseAlerFrame
   {
      
      public static const TIME:int = 10;
       
      
      private var _alertInfo:AlertInfo;
      
      private var _showTxt:FilterFrameText;
      
      private var _timeTxt:FilterFrameText;
      
      private var _tick:int;
      
      private var _ifShow:Boolean = true;
      
      private var _waiting:Boolean = false;
      
      public function ArenaReassignedView()
      {
         super();
         this.initView();
      }
      
      public function get ifShow() : Boolean
      {
         return this._ifShow;
      }
      
      private function initView() : void
      {
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._showTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.arenaReassignedView.showTxt");
         this._showTxt.text = LanguageMgr.GetTranslation("ddt.arena.arenareassigned.showtxt");
         addToContent(this._showTxt);
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("ddtarena.arenaReassignedView.timeTxt");
         this._timeTxt.htmlText = LanguageMgr.GetTranslation("ddt.arena.arenareassigned.timetxt",10);
         addToContent(this._timeTxt);
      }
      
      private function initEvent() : void
      {
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__seconds);
      }
      
      private function __seconds(param1:TimeEvents) : void
      {
         --this._tick;
         this._timeTxt.htmlText = LanguageMgr.GetTranslation("ddt.arena.arenareassigned.timetxt",this._tick);
         if(this._tick == 0)
         {
            this._ifShow = false;
            this.hide();
         }
      }
      
      private function removeEvent() : void
      {
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__seconds);
      }
      
      override protected function __onSubmitClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         super.__onSubmitClick(param1);
         ArenaManager.instance.sendExit();
         ArenaManager.instance.sendEnterScene();
         this.hide();
      }
      
      override protected function __onCancelClick(param1:MouseEvent) : void
      {
         super.__onCancelClick(param1);
         this._ifShow = false;
         this.hide();
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         super.__onCloseClick(param1);
         this._ifShow = false;
         this.hide();
      }
      
      public function show() : void
      {
         if(ArenaManager.instance.model.selfInfo.sceneID == 1)
         {
            return;
         }
         if(StateManager.currentStateType == StateType.ARENA && this.ifShow)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this._tick = TIME;
            this.initEvent();
            this._waiting = false;
         }
         else
         {
            this._waiting = true;
         }
      }
      
      public function check() : void
      {
         if(this._waiting)
         {
            this.show();
         }
      }
      
      public function hide() : void
      {
         this.removeEvent();
         parent.removeChild(this);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}
