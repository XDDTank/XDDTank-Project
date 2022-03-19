// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.SkillManager

package ddt.manager
{
    import flash.display.MovieClip;
    import com.pickgliss.utils.ClassUtils;
    import game.objects.SkillType;
    import game.view.effects.ReduceStrengthEffect;
    import game.GameManager;
    import game.model.Living;
    import game.view.effects.MirariEffectIconManager;
    import game.objects.MirariType;
    import game.view.effects.LimitMaxForceEffectIcon;
    import game.model.Player;
    import game.view.effects.BaseMirariEffectIcon;
    import road7th.comm.PackageIn;

    public class SkillManager 
    {


        public static function solveWeaponSkillMovieName(_arg_1:int):String
        {
            return (solveSkillMovieName(_arg_1));
        }

        public static function solveSkillMovieName(_arg_1:int):String
        {
            return ("tank.resource.skill.weapon" + _arg_1);
        }

        public static function createWeaponSkillMovieAsset(_arg_1:int):MovieClip
        {
            return (createSkillMovieAsset(_arg_1));
        }

        public static function createSkillMovieAsset(_arg_1:int):MovieClip
        {
            return (ClassUtils.CreatInstance(solveSkillMovieName(_arg_1)) as MovieClip);
        }

        public static function applySkillToLiving(_arg_1:int, _arg_2:int, ... _args):void
        {
            switch (_arg_1)
            {
                case SkillType.ForbidFly:
                    applyForbidFly(_arg_2);
                    return;
                case SkillType.ReduceDander:
                    applyReduceDander(_arg_2, _args[0]);
                    return;
                case SkillType.ChangeTurnTime:
                    applyChangeTurnTime(_arg_2, _args[0], _args[1]);
                    return;
                case SkillType.LimitMaxForce:
                    applyLimitMaxForce(_arg_2, _args[0]);
                    return;
                case SkillType.ReduceStrength:
                    applyReduceStrength(_arg_2, _args[0]);
                    return;
                case SkillType.ResolveHurt:
                    applyResolveHurt(_arg_2, _args[0]);
                    return;
                case SkillType.Revert:
                    applyRevert(_arg_2, _args[0]);
                    return;
            };
        }

        public static function removeSkillFromLiving(_arg_1:int, _arg_2:int, ... _args):void
        {
            switch (_arg_1)
            {
                case SkillType.ResolveHurt:
                    removeResolveHurt(_arg_2, _args[0]);
                    return;
            };
        }

        private static function applyReduceStrength(_arg_1:int, _arg_2:int):void
        {
            var _local_4:ReduceStrengthEffect;
            var _local_3:Living = GameManager.Instance.Current.findLiving(_arg_1);
            if (((_local_3.isPlayer()) && (_local_3.isLiving)))
            {
                _local_4 = (MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ReduceStrength) as ReduceStrengthEffect);
                _local_4.strength = _arg_2;
                if (_local_4 != null)
                {
                };
            };
        }

        private static function applyLimitMaxForce(_arg_1:int, _arg_2:int):void
        {
            var _local_4:LimitMaxForceEffectIcon;
            var _local_3:Living = GameManager.Instance.Current.findLiving(_arg_1);
            if (((_local_3.isPlayer()) && (_local_3.isLiving)))
            {
                _local_4 = (MirariEffectIconManager.getInstance().createEffectIcon(MirariType.LimitMaxForce) as LimitMaxForceEffectIcon);
                _local_4.force = _arg_2;
                if (_local_4 != null)
                {
                };
            };
        }

        private static function applyChangeTurnTime(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_5:Player;
            var _local_4:Living = GameManager.Instance.Current.findLiving(_arg_1);
            if (((_local_4.isPlayer()) && (_local_4.isLiving)))
            {
                _local_5 = (_local_4 as Player);
            };
        }

        private static function applyReduceDander(_arg_1:int, _arg_2:int):void
        {
            var _local_4:Player;
            var _local_3:Living = GameManager.Instance.Current.findLiving(_arg_1);
            if (((_local_3.isPlayer()) && (_local_3.isLiving)))
            {
                _local_4 = (_local_3 as Player);
                _local_4.dander = _arg_2;
            };
        }

        private static function applyForbidFly(_arg_1:int):void
        {
            var _local_2:Living = GameManager.Instance.Current.findLiving(_arg_1);
            var _local_3:BaseMirariEffectIcon = MirariEffectIconManager.getInstance().createEffectIcon(MirariType.DisenableFly);
            if (((!(_local_3 == null)) && (_local_2.isLiving)))
            {
            };
        }

        private static function applyResolveHurt(_arg_1:int, _arg_2:PackageIn):void
        {
            var _local_3:Living = GameManager.Instance.Current.findLiving(_arg_1);
            if (_local_3.isLiving)
            {
                _local_3.applySkill(SkillType.ResolveHurt, _arg_2);
            };
        }

        private static function removeResolveHurt(_arg_1:int, _arg_2:PackageIn):void
        {
            var _local_4:Player;
            var _local_3:Living = GameManager.Instance.Current.findLiving(_arg_1);
            if ((((_local_3) && (_local_3.isPlayer())) && (_local_3.isLiving)))
            {
                _local_4 = Player(_local_3);
                _local_4.removeSkillMovie(2);
                _local_4.removeMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
            };
            var _local_5:int = _arg_2.readInt();
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                _local_3 = GameManager.Instance.Current.findLiving(_arg_2.readInt());
                if (((_local_3.isPlayer()) && (_local_3.isLiving)))
                {
                    _local_4 = Player(_local_3);
                    _local_4.removeSkillMovie(2);
                    _local_4.removeMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
                };
                _local_6++;
            };
        }

        private static function applyRevert(_arg_1:int, _arg_2:PackageIn):void
        {
            var _local_3:Living = GameManager.Instance.Current.findLiving(_arg_1);
            if (_local_3.isLiving)
            {
                _local_3.applySkill(SkillType.Revert, _arg_2);
            };
        }


    }
}//package ddt.manager

