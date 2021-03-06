package com.monogramm.starter.persistence.permission.service;

import com.monogramm.starter.config.security.IAuthenticationFacade;
import com.monogramm.starter.dto.permission.PermissionDto;
import com.monogramm.starter.persistence.AbstractGenericService;
import com.monogramm.starter.persistence.permission.dao.PermissionRepository;
import com.monogramm.starter.persistence.permission.entity.Permission;
import com.monogramm.starter.persistence.permission.exception.PermissionNotFoundException;
import com.monogramm.starter.persistence.user.dao.UserRepository;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * {@link Permission} service.
 * 
 * @author madmath03
 */
@Service
public class PermissionServiceImpl extends AbstractGenericService<Permission, PermissionDto>
    implements PermissionService {

  /**
   * Create a {@link PermissionServiceImpl}.
   * 
   * @param permissionDao the permission repository.
   * @param userDao the user repository.
   * @param authenticationFacade a facade to retrieve the authentication object.
   */
  @Autowired
  public PermissionServiceImpl(final PermissionRepository permissionDao,
      final UserRepository userDao, IAuthenticationFacade authenticationFacade) {
    super(permissionDao, userDao, new PermissionBridge(userDao), authenticationFacade);
  }

  @Override
  protected PermissionRepository getRepository() {
    return (PermissionRepository) super.getRepository();
  }

  @Override
  public PermissionBridge getBridge() {
    return (PermissionBridge) super.getBridge();
  }

  @Override
  protected boolean exists(Permission entity) {
    return getRepository().exists(entity.getId(), entity.getName());
  }

  @Override
  protected PermissionNotFoundException createEntityNotFoundException(Permission entity) {
    return new PermissionNotFoundException("Following permission not found:" + entity);
  }

  @Override
  protected PermissionNotFoundException createEntityNotFoundException(UUID entityId) {
    return new PermissionNotFoundException("No permission for ID=" + entityId);
  }

  @Transactional(readOnly = true)
  @Override
  public Permission findByName(final String name) {
    return getRepository().findByNameIgnoreCase(name);
  }

  @Transactional(readOnly = true)
  @Override
  public List<Permission> findAllByName(final String name) {
    return getRepository().findAllContainingNameIgnoreCase(name);
  }
}
