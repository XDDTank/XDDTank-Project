// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossConfirmFrame

package worldboss.view
{
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;

    public class WorldBossConfirmFrame extends WorldBossBuyBuffConfirmFrame 
    {

        protected var _responseCellBack:Function;
        protected var _selectedCheckButtonCellBack:Function;


        public function showFrame(_arg_1:String, _arg_2:String, _arg_3:Function=null, _arg_4:Function=null):void
        {
            var _local_5:AlertInfo = this.info;
            _local_5.title = _arg_1;
            _alertTips.text = _arg_2;
            this._responseCellBack = _arg_3;
            this._selectedCheckButtonCellBack = _arg_4;
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override protected function __framePesponse(_arg_1:FrameEvent):void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__framePesponse);
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    dispose();
                    break;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (this._responseCellBack != null)
                    {
                        this._responseCellBack();
                    };
                    break;
            };
            dispose();
        }

        override protected function __noAlertTip(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            if (this._selectedCheckButtonCellBack != null)
            {
                this._selectedCheckButtonCellBack();
            };
        }


    }
}//package worldboss.view

