package consortion.consortionTask
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   
   public class ConsortionTaskViewFrame extends Frame
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _levelIcon1:ConsortionTaskLevelItem;
      
      private var _levelIcon2:ConsortionTaskLevelItem;
      
      private var _levelIcon3:ConsortionTaskLevelItem;
      
      private var _levelIcon4:ConsortionTaskLevelItem;
      
      private var _iconList:Vector.<ConsortionTaskLevelItem>;
      
      private var _publishTaskBtn:IconButton;
      
      private var _currentTaskLevel:int = 11;
      
      public function ConsortionTaskViewFrame()
      {
         super();
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionTaskViewBg");
         addToContent(this._bg);
         titleText = LanguageMgr.GetTranslation("consortion.ConsortionTask.publish") + LanguageMgr.GetTranslation("consortion.consortionTask.title.text");
         this._levelIcon1 = new ConsortionTaskLevelItem(ConsortionModel.TASKLEVELI);
         this._levelIcon2 = new ConsortionTaskLevelItem(ConsortionModel.TASKLEVELII);
         this._levelIcon3 = new ConsortionTaskLevelItem(ConsortionModel.TASKLEVELIII);
         this._levelIcon4 = new ConsortionTaskLevelItem(ConsortionModel.TASKLEVELIV);
         PositionUtils.setPos(this._levelIcon1,"taskLevelIconI.pos");
         PositionUtils.setPos(this._levelIcon2,"taskLevelIconII.pos");
         PositionUtils.setPos(this._levelIcon3,"taskLevelIconIII.pos");
         PositionUtils.setPos(this._levelIcon4,"taskLevelIconIV.pos");
         this._levelIcon1.addEventListener(ConsortionEvent.CONSORTION_TASK_LEVEL_CHANGE,this.__changeTaskLevel);
         this._levelIcon2.addEventListener(ConsortionEvent.CONSORTION_TASK_LEVEL_CHANGE,this.__changeTaskLevel);
         this._levelIcon3.addEventListener(ConsortionEvent.CONSORTION_TASK_LEVEL_CHANGE,this.__changeTaskLevel);
         this._levelIcon4.addEventListener(ConsortionEvent.CONSORTION_TASK_LEVEL_CHANGE,this.__changeTaskLevel);
         this._iconList = new Vector.<ConsortionTaskLevelItem>();
         this._iconList.push(this._levelIcon1);
         this._iconList.push(this._levelIcon2);
         this._iconList.push(this._levelIcon3);
         this._iconList.push(this._levelIcon4);
         addToContent(this._levelIcon1);
         addToContent(this._levelIcon2);
         addToContent(this._levelIcon3);
         addToContent(this._levelIcon4);
         this._levelIcon1.selected = true;
         this.checkButtonEnable();
         this._publishTaskBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.BtnPublishTask");
         addToContent(this._publishTaskBtn);
         this._publishTaskBtn.addEventListener(MouseEvent.CLICK,this.showAlert);
      }
      
      private function checkButtonEnable() : void
      {
         switch(ConsortionModelControl.Instance.model.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level).QuestLevel)
         {
            case ConsortionModel.TASKLEVELI:
               this._levelIcon2.enable = false;
               this._levelIcon3.enable = false;
               this._levelIcon4.enable = false;
               break;
            case ConsortionModel.TASKLEVELII:
               this._levelIcon3.enable = false;
               this._levelIcon4.enable = false;
               break;
            case ConsortionModel.TASKLEVELIII:
               this._levelIcon4.enable = false;
         }
      }
      
      private function showAlert(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortion.ConsortionTask.title.text"),LanguageMgr.GetTranslation("consortion.task.contribution",ConsortionModelControl.Instance.model.getTaskCost(this._currentTaskLevel)),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
      }
      
      private function __changeTaskLevel(param1:ConsortionEvent) : void
      {
         switch(param1.data)
         {
            case ConsortionModel.TASKLEVELI:
               this._currentTaskLevel = ConsortionModel.TASKLEVELI;
               this.selectIcon(this._levelIcon1);
               break;
            case ConsortionModel.TASKLEVELII:
               this._currentTaskLevel = ConsortionModel.TASKLEVELII;
               this.selectIcon(this._levelIcon2);
               break;
            case ConsortionModel.TASKLEVELIII:
               this._currentTaskLevel = ConsortionModel.TASKLEVELIII;
               this.selectIcon(this._levelIcon3);
               break;
            case ConsortionModel.TASKLEVELIV:
               this._currentTaskLevel = ConsortionModel.TASKLEVELIV;
               this.selectIcon(this._levelIcon4);
         }
      }
      
      private function selectIcon(param1:ConsortionTaskLevelItem) : void
      {
         var _loc2_:ConsortionTaskLevelItem = null;
         for each(_loc2_ in this._iconList)
         {
            _loc2_.selected = false;
         }
         param1.selected = true;
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendConsortionPublishTask(this._currentTaskLevel);
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         ConsortionModelControl.Instance.addEventListener(ConsortionEvent.REFLASH_CAMPAIGN_ITEM,this.__publicComplete);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __publicComplete(param1:ConsortionEvent) : void
      {
         this.dispose();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._levelIcon1);
         this._levelIcon1 = null;
         ObjectUtils.disposeObject(this._levelIcon2);
         this._levelIcon2 = null;
         ObjectUtils.disposeObject(this._levelIcon3);
         this._levelIcon3 = null;
         ObjectUtils.disposeObject(this._levelIcon4);
         this._levelIcon4 = null;
         this._iconList = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
