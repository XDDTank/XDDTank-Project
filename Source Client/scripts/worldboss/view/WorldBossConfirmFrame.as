package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class WorldBossConfirmFrame extends WorldBossBuyBuffConfirmFrame
   {
       
      
      protected var _responseCellBack:Function;
      
      protected var _selectedCheckButtonCellBack:Function;
      
      public function WorldBossConfirmFrame()
      {
         super();
      }
      
      public function showFrame(param1:String, param2:String, param3:Function = null, param4:Function = null) : void
      {
         var _loc5_:AlertInfo = this.info;
         _loc5_.title = param1;
         _alertTips.text = param2;
         this._responseCellBack = param3;
         this._selectedCheckButtonCellBack = param4;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override protected function __framePesponse(param1:FrameEvent) : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this._responseCellBack != null)
               {
                  this._responseCellBack();
               }
         }
         dispose();
      }
      
      override protected function __noAlertTip(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedCheckButtonCellBack != null)
         {
            this._selectedCheckButtonCellBack();
         }
      }
   }
}
