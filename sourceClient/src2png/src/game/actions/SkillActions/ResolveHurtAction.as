// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.SkillActions.ResolveHurtAction

package game.actions.SkillActions
{
    import road7th.comm.PackageIn;
    import game.model.Living;
    import game.animations.IAnimate;
    import game.model.Player;
    import com.pickgliss.effect.BaseEffect;
    import game.GameManager;
    import game.view.effects.MirariEffectIconManager;
    import game.objects.MirariType;

    public class ResolveHurtAction extends SkillAction 
    {

        private var _pkg:PackageIn;
        private var _scr:Living;

        public function ResolveHurtAction(_arg_1:IAnimate, _arg_2:Living, _arg_3:PackageIn)
        {
            this._pkg = _arg_3;
            this._scr = _arg_2;
            super(_arg_1);
        }

        override protected function finish():void
        {
            var _local_2:Player;
            var _local_3:BaseEffect;
            var _local_5:Living;
            var _local_1:int = this._pkg.readInt();
            var _local_4:int;
            while (_local_4 < _local_1)
            {
                _local_5 = GameManager.Instance.Current.findLiving(this._pkg.readInt());
                if (((_local_5.isPlayer()) && (_local_5.isLiving)))
                {
                    _local_2 = Player(_local_5);
                    _local_2.handleMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
                };
                _local_4++;
            };
            _local_2 = Player(this._scr);
            _local_2.handleMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
            super.finish();
        }


    }
}//package game.actions.SkillActions

