package com.alphas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.alphas.order.dto.UserInfo;

@Repository
public interface UserInfoRepository extends JpaRepository<UserInfo, Long>{

}

