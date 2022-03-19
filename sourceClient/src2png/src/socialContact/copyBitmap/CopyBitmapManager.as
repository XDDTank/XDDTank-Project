// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//socialContact.copyBitmap.CopyBitmapManager

package socialContact.copyBitmap
{
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.KeyboardEvent;
    import flash.net.FileReference;

    public class CopyBitmapManager 
    {

        private static var _instance:CopyBitmapManager;

        private const P_KEY:int = 80;

        private var _view:CopyBitmapFrame;
        private var _mode:CopyBitmapMode;
        private var _saveBmpMode:CopyBitmapSaveBmp;


        public static function get Instance():CopyBitmapManager
        {
            if (_instance == null)
            {
                _instance = new (CopyBitmapManager)();
            };
            return (_instance);
        }


        public function init():void
        {
            this._saveBmpMode = new CopyBitmapSaveBmp();
            this._addEvt();
        }

        private function _addEvt():void
        {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_UP, this._stageKeyUp);
        }

        private function _stageKeyUp(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == this.P_KEY)
            {
                this._show();
            };
        }

        private function _show():void
        {
            if (((this._mode) && (this._view)))
            {
                return;
            };
            this._mode = new CopyBitmapMode();
            this._view = new CopyBitmapFrame(this._mode);
            this._view.show();
        }

        private function get mode():CopyBitmapMode
        {
            return (this._mode);
        }

        public function close():void
        {
            this._view.dispose();
            if (this._view.parent)
            {
                this._view.parent.removeChild(this._view);
            };
            this._view = null;
            this._mode = null;
        }

        public function saveBmp():void
        {
            this._saveBmpMode.copyBmp(this._mode.startX, this._mode.startY, this._mode.endX, this._mode.endY);
            this.close();
            var _local_1:FileReference = new FileReference();
            _local_1.save(this._saveBmpMode.bitmapData);
        }


    }
}//package socialContact.copyBitmap

