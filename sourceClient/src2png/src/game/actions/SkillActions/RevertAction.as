// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.SkillActions.RevertAction

package game.actions.SkillActions
{
    import road7th.comm.PackageIn;
    import game.model.Living;
    import game.animations.IAnimate;
    import __AS3__.vec.Vector;
    import game.GameManager;
    import __AS3__.vec.*;

    public class RevertAction extends SkillAction 
    {

        private var _pkg:PackageIn;
        private var _src:Living;

        public function RevertAction(_arg_1:IAnimate, _arg_2:Living, _arg_3:PackageIn)
        {
            this._pkg = _arg_3;
            this._src = _arg_2;
            super(_arg_1);
        }

        override protected function finish():void
        {
            var _local_5:Living;
            var _local_1:int = this._pkg.readInt();
            var _local_2:Vector.<Living> = new Vector.<Living>();
            var _local_3:int;
            while (_local_3 < _local_1)
            {
                _local_2.push(GameManager.Instance.Current.findLiving(this._pkg.readInt()));
                _local_3++;
            };
            var _local_4:int = this._pkg.readInt();
            for each (_local_5 in _local_2)
            {
                _local_5.updateBlood((_local_5.blood + _local_4), 0, _local_4);
            };
            super.finish();
        }


    }
}//package game.actions.SkillActions

