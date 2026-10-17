--[VAACT] [ANIME] ~Natural Selection~ (Sélection Naturelle)
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local TOKEN_ID = 910001148 -- ID du Jeton Sélection
-- ==================================

function s.initial_effect(c)
	-- Activation du piège (uniquement durant le tour de l'adversaire)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- Condition : Seulement pendant le tour de l'adversaire
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function s.filter(c)
	return c:IsFaceup() and c:IsMonster()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) 
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_MZONE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		-- Sauvegarde des stats du monstre AVANT de le détruire
		local level = tc:GetLevel()
		local race = tc:GetRace()
		local attr = tc:GetAttribute()
		local atk = tc:GetAttack()
		local def = tc:GetDefense()
		local code = tc:GetCode() -- Pour l'apparence du jeton

		-- Destruction du monstre adverse
		if Duel.Destroy(tc, REASON_EFFECT)~=0 then
			-- Vérification de la place pour invoquer le jeton
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
				and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_ID,0,TYPES_TOKEN,atk,def,level,race,attr,POS_FACEUP_ATTACK) then
				
				-- Création et invocation spéciale du Jeton Sélection
				local token=Duel.CreateToken(tp,TOKEN_ID)
				
				-- Application des stats copiées au Jeton
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(level)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e1)
				
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RACE)
				e2:SetValue(race)
				token:RegisterEffect(e2)
				
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e3:SetValue(attr)
				token:RegisterEffect(e3)
				
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_ATTACK)
				e4:SetValue(atk)
				token:RegisterEffect(e4)
				
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_DEFENSE)
				e5:SetValue(def)
				token:RegisterEffect(e5)

				if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)>0 then
					-- Destruction à la End Phase
					local e6=Effect.CreateEffect(c)
					e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e6:SetCode(EVENT_PHASE+PHASE_END)
					e6:SetCountLimit(1)
					e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e6:SetLabelObject(token)
					e6:SetOperation(s.desop)
					e6:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e6,tp)
				end
			end
		end
	end
end

-- Opération de destruction à la End Phase
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc, REASON_EFFECT)
	end
end